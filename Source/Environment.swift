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
            return .Failure(.CreateDirectoryError(error))
        }

        var env: COpaquePointer = nil
        var ret = mdb_env_create(&env)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        ret = mdb_env_open(env, path, 0, 0o644)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success(self.init(path: path, env: nil))
    }

    /// Wrapper for `mdb_env_stat`.
    public func stat() -> MDB_stat {
        var stat = MDB_stat()
        mdb_env_stat(env, &stat)
        return stat
    }

    /// Wrapper for `mdb_env_info`.
    public func info() -> MDB_envinfo {
        var info = MDB_envinfo()
        mdb_env_info(env, &info)
        return info
    }

    /// The directory path to this environment.
    public let path: String

    /// The lmdb environment handle.
    internal let env: COpaquePointer

    private init(path: String, env: COpaquePointer) {
        self.path = path
        self.env = env
    }

    deinit {
        mdb_env_close(env)
    }
}
