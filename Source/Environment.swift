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

        return .Success(self.init(path: path, handle: handle))
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

    private init(path: String, handle: COpaquePointer) {
        self.path = path
        self.handle = handle
    }

    deinit {
        mdb_env_close(handle)
    }
}
