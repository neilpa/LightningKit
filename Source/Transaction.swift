//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import Result
import lmdb

/// Opaque wrapper for an LMDB transaction.
public struct Transaction {
    internal let txn: COpaquePointer

    /// Start a new transaction in the given `environment`.
    public static func begin(environment: Environment, readOnly: Bool = false, parent: Transaction? = nil) -> Result<Transaction, ElephantError> {
        var txn: COpaquePointer = nil
        let flags = readOnly ? UInt32(MDB_RDONLY) : 0

        let ret = mdb_txn_begin(environment.env, parent?.txn ?? nil, flags, &txn)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success(self.init(txn: txn))
    }

    public func commit() -> Result<(), ElephantError> {
        let ret = mdb_txn_commit(txn)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success()
    }

    public func abort() {
        mdb_txn_abort(txn)
    }

    private init(txn: COpaquePointer) {
        self.txn = txn
    }
}
