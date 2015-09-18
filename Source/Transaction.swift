//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb
import Result

/// Opaque wrapper for an LMDB transaction.
//  TODO Should probably be `final class`
public struct Transaction {
    internal let handle: COpaquePointer

    /// Start a new transaction in the given `environment`.
    public static func begin(environment: Environment, writeable: Bool = false, parent: Transaction? = nil) -> Result<Transaction, ElephantError> {
        var handle: COpaquePointer = nil
        let flags = writeable ? 0 : UInt32(MDB_RDONLY)

        let ret = mdb_txn_begin(environment.handle, parent?.handle ?? nil, flags, &handle)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success(self.init(handle: handle))
    }

    /// Commits changes executed during this transaction.
    public func commit() -> Result<(), ElephantError> {
        let ret = mdb_txn_commit(handle)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success()
    }

    /// Aborts any changes executed during this transaction.
    public func abort() {
        mdb_txn_abort(handle)
    }

    private init(handle: COpaquePointer) {
        self.handle = handle
    }
}
