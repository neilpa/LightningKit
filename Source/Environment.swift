//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Foundation
import Result

/// Wrapper for an LMDB environment.
public final class Environment {

    /// Open or create an LMDB environment at `path`.
    public static func open(path: String) -> Result<Environment, LightningError> {
        let fs = NSFileManager.defaultManager()
        do {
            try fs.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            return .fsError(error)
        }

        return lmdbTry(mdb_env_create).flatMap { handle in
            lmdbTry(mdb_env_open(handle, path, 0, 0o600)).flatMap { _ in
                // Transaction.query
                return query(handle) { txn in
                    return lmdbTry(txn, nil, 0, mdb_dbi_open)
                }
                .map { Environment(handle: handle, dbi: $0) }
                .on(failure: { _ in mdb_env_close(handle) })
            }
        }
    }

    /// Opens a read-only transaction for querying the database. If `fn` succeeds the
    /// transaction will be committed, otherwise it's aborted.
    internal static func query<T>(env: COpaquePointer, fn: COpaquePointer -> Result<T, LightningError>) -> Result<T, LightningError> {
        return lmdbTry(env, nil, UInt32(MDB_RDONLY), mdb_txn_begin)
            .transact(fn,
                commit: {
                    return lmdbTry(mdb_txn_commit($0)).error
                },
                abort: mdb_txn_abort)
    }

    /// Wrapper for `mdb_env_stat`.
    public func stat() -> MDB_stat {
        var stat = MDB_stat()
        mdb_env_stat(handle, &stat)
        return stat
    }

    /// Wrapper for `mdb_env_info`.
    public func info() -> MDB_envinfo {
        var info = MDB_envinfo()
        mdb_env_info(handle, &info)
        return info
    }

    /// The LMDB environment handle.
    internal let handle: COpaquePointer

    /// The root (e.g. unamed) database for this enviroment.
    internal let db: Database

    private init(handle: COpaquePointer, dbi: MDB_dbi) {
        self.handle = handle
        db = Database(dbi: dbi)
    }

    deinit {
        mdb_env_close(handle)
    }
}
