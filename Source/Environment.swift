//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb
import Foundation
import Result

/// Wrapper for an LMDB environment.
public final class Environment {

    /// Open or create an LMDB environment at `path`.
    public static func open(path: String) -> Result<Environment, ElephantError> {
        let fs = NSFileManager.defaultManager()
        do {
            try fs.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            return .fsError(error)
        }

        var handle: COpaquePointer = nil
        var err = mdb_env_create(&handle)

        guard err == 0 else {
            return .lmdbError(err)
        }

        err = mdb_env_open(handle, path, 0, 0o600)
        guard err == 0 else {
            return .lmdbError(err)
        }

        // Temp transaction to open the primary database instance
        return query(handle) { txn in
            var dbi = MDB_dbi()
            err = mdb_dbi_open(txn, nil, 0, &dbi)
            guard err == 0 else {
                return .lmdbError(err)
            }

            return .Success(dbi)
        }
        .analysis(
            ifSuccess: { dbi in
                return .Success(self.init(path: path, handle: handle, dbi: dbi))
            },
            ifFailure: { error in
                mdb_env_close(handle)
                return .Failure(error)
            })
    }

    /// Opens a read-only transaction for querying the database. If `fn` succeeds the
    /// transaction will be committed, otherwise it's aborted.
    internal static func query<T>(env: COpaquePointer, fn: COpaquePointer -> Result<T, ElephantError>) -> Result<T, ElephantError> {
        var txn: COpaquePointer = nil
        let err = mdb_txn_begin(env, nil, UInt32(MDB_RDONLY), &txn)
        guard err == 0 else {
            return .lmdbError(err)
        }

        return fn(txn).analysis(
            ifSuccess: { value in
                let err = mdb_txn_commit(txn)
                return err == 0 ? .Success(value) : .lmdbError(err)
            }, ifFailure: { failure in
                mdb_txn_abort(txn)
                return .Failure(failure)
            })
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

    /// The directory path to this environment.
    public let path: String

    /// The LMDB environment handle.
    internal let handle: COpaquePointer

    /// The root (e.g. unamed) database for this enviroment.
    internal let dbi: MDB_dbi

    private init(path: String, handle: COpaquePointer, dbi: MDB_dbi) {
        self.path = path
        self.handle = handle
        self.dbi = dbi
    }

    deinit {
        mdb_env_close(handle)
    }
}
