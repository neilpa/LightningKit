//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb
import Result

/// Opaque wrapper for an LMDB transaction.
public final class Transaction {
    internal let handle: COpaquePointer

    /// Start a new transaction in the given `environment`.
    public static func begin(environment: Environment, writeable: Bool = false, parent: Transaction? = nil) -> Result<Transaction, ElephantError> {
        var handle: COpaquePointer = nil
        let flags = writeable ? 0 : UInt32(MDB_RDONLY)

        let err = mdb_txn_begin(environment.handle, parent?.handle ?? nil, flags, &handle)
        guard err == 0 else {
            return .lmdbError(err)
        }

        return .Success(self.init(handle: handle))
    }

    /// Commits changes executed during this transaction.
    public func commit() -> Result<(), ElephantError> {
        let err = mdb_txn_commit(handle)
        guard err == 0 else {
            return .lmdbError(err)
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

    deinit {
        // TODO?
    }
}
