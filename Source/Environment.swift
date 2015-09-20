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
            return .Failure(.FileSystem(error))
        }

        var handle: COpaquePointer = nil
        return mdbTry(mdb_env_create(&handle))
            .flatMap { _ in mdbTry(mdb_env_open(handle, path, 0, 0o600)) }
            .flatMap { _ in
                // Open the primary DB in a temporary read-only transaction
                var txn: COpaquePointer = nil
                return mdbTry(mdb_txn_begin(handle, nil, UInt32(MDB_RDONLY), &txn))
                    .flatMap { _ in
                        var dbi = MDB_dbi()
                        return mdbTry(mdb_dbi_open(txn, nil, 0, &dbi))
                            .map { _ in Environment(handle: handle, dbi: dbi) }
                            .on(failure: { _ in mdb_txn_abort(txn) })
                    }
                    .on(success: { _ in mdbTry(mdb_txn_commit(txn)).error })
            }
            .on(failure: { _ in mdb_env_close(handle) })
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

    /// The root (e.g. unnamed) database for this enviroment.
    public var db: Database!

    /// The LMDB environment handle.
    internal let handle: COpaquePointer

    private init(handle: COpaquePointer, dbi: MDB_dbi) {
        self.handle = handle
        db = Database(dbi: dbi, env: self)
    }

    deinit {
        mdb_env_close(handle)
    }
}
