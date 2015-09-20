//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Result

/// Opaque wrapper for an LMDB transaction.
public final class Transaction {
    /// Start a new transaction in the given `environment`.
    public static func begin(env: Environment, parent: Transaction? = nil, writeable: Bool = false, db: Database? = nil) -> Result<Transaction, LightningError> {
        var handle: COpaquePointer = nil
        let flags = writeable ? 0 : UInt32(MDB_RDONLY)

        return mdbTry(mdb_txn_begin(env.handle, parent?.handle ?? nil, flags, &handle))
            .map { _ in Transaction(handle: handle, env: env, db: db) }
    }

    /// Commits changes executed during this transaction.
    public func commit() -> Result<(), LightningError> {
        return mdbTry(mdb_txn_commit(handle))
    }

    /// Aborts any changes executed during this transaction.
    public func abort() {
        mdb_txn_abort(handle)
    }

    /// Associates `data` with the provided `key`. This is a wrapper for `mdb_put`.
    internal func put(key key: ByteBuffer, data: ByteBuffer) -> Result<(), LightningError> {
        // The key and value buffers aren't modified for a put.
        var keyVal = MDB_val(buffer: key)
        var dataVal = MDB_val(buffer: data)

        return mdbTry(mdb_put(handle, db.dbi, &keyVal, &dataVal, 0))
    }

    /// Retuns the data associated with the provided `key`. This is a wrapper for `mdb_get`.
    internal func get(key: ByteBuffer) -> Result<ByteBuffer, LightningError> {
        // The key buffer isn't modified for a get.
        var keyVal = MDB_val(buffer: key)
        var dataVal = MDB_val()

        return mdbTry(mdb_get(handle, db.dbi, &keyVal, &dataVal)).map { _ in
            let data = unsafeBitCast(dataVal.mv_data, UnsafePointer<UInt8>.self)
            return ByteBuffer(start: data, count: dataVal.mv_size)
        }
    }

    /// Deletes the `key` and associated `data` from the database. This is a wrapper for `mdb_del`.
    internal func del(key: ByteBuffer) -> Result<(), LightningError> {
        var keyVal = MDB_val(buffer: key)

        // TODO Support for duplicates (MDB_SORTDUP)
        return mdbTry(mdb_del(handle, db.dbi, &keyVal, nil))
    }

    /// The environment owning this transaction.
    public let env: Environment

    /// The default database to perform operations against.
    public let db: Database

    /// The handle to the underlying transaction.
    internal let handle: COpaquePointer

    private init(handle: COpaquePointer, env: Environment, db: Database?) {
        self.handle = handle
        self.env = env
        self.db = db ?? env.db
    }
}
