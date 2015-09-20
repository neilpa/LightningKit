//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Result

/// Opaque wrapper for an LMDB transaction.
public final class Transaction {
    internal let handle: COpaquePointer
    internal let dbi: MDB_dbi

    /// Start a new transaction in the given `environment`.
    public static func begin(env: Environment, parent: Transaction? = nil, writeable: Bool = false, db: Database? = nil) -> Result<Transaction, LightningError> {
        let flags = writeable ? 0 : UInt32(MDB_RDONLY)
        return begin(env.handle, parent?.handle ?? nil, flags, db?.dbi ?? env.db.dbi)
    }

    internal static func begin(envHandle: COpaquePointer, _ parentHandle: COpaquePointer, _ flags: UInt32, _ dbi: MDB_dbi) -> Result<Transaction, LightningError> {
        var handle: COpaquePointer = nil
        return mdbTry(mdb_txn_begin(envHandle, parentHandle, flags, &handle))
            .map { _ in Transaction(handle: handle, dbi: dbi) }
    }

    /// Commits changes executed during this transaction.
    public func commit() -> Result<(), LightningError> {
        let err = mdb_txn_commit(handle)
        guard err == 0 else {
            return .mdbError(err)
        }

        return .Success()
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

        let err = mdb_put(handle, dbi, &keyVal, &dataVal, 0)
        guard err == 0 else {
            return .mdbError(err)
        }

        return .Success()
    }

    /// Retuns the data associated with the provided `key`. This is a wrapper for `mdb_get`.
    internal func get(key: ByteBuffer) -> Result<ByteBuffer, LightningError> {
        // The key buffer isn't modified for a get.
        var keyVal = MDB_val(buffer: key)
        var dataVal = MDB_val()

        let err = mdb_get(handle, dbi, &keyVal, &dataVal)
        guard err == 0 else {
            return .mdbError(err)
        }

        let data = unsafeBitCast(dataVal.mv_data, UnsafePointer<UInt8>.self)
        return .Success(ByteBuffer(start: data, count: dataVal.mv_size))
    }

    /// Deletes the `key` and associated `data` from the database. This is a wrapper for `mdb_del`.
    internal func del(key: ByteBuffer) -> Result<(), LightningError> {
        var keyVal = MDB_val(buffer: key)

        // TODO Support for duplicates (MDB_SORTDUP)
        let err = mdb_del(handle, dbi, &keyVal, nil)
        guard err == 0 else {
            return .mdbError(err)
        }

        return .Success()
    }

    private init(handle: COpaquePointer, dbi: MDB_dbi) {
        self.handle = handle
        self.dbi = dbi
    }

    deinit {
        // TODO?
    }
}
