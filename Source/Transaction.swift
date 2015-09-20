//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Result

/// Opaque wrapper for an LMDB transaction.
public final class Transaction {
    internal let handle: COpaquePointer
    internal let env: Environment

    /// Start a new transaction in the given `environment`.
    public static func begin(env: Environment, writeable: Bool = false, parent: Transaction? = nil) -> Result<Transaction, LightningError> {
        let flags = writeable ? 0 : UInt32(MDB_RDONLY)
        return lmdbTry(env.handle, parent?.handle ?? nil, flags, mdb_txn_begin).map {
            return self.init(env: env, handle: $0)
        }
    }

    public func cursor() -> Result<Cursor, LightningError> {
        return Database.open(self).flatMap {
            return Cursor.open($0)
        }
//        return Cursor.open()
//        mdb_cursor_open
    }
    
    /// Commits changes executed during this transaction.
    public func commit() -> Result<(), LightningError> {
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

    private init(env: Environment, handle: COpaquePointer) {
        self.env = env
        self.handle = handle
    }

    deinit {
        // TODO?
    }
}
