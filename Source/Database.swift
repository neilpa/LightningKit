//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb
import Result

/// Opaque wrapper for an LMDB database instance.
internal struct Database {
    /// The handle to the transaction
    internal let txn: COpaquePointer

    /// The wrapped database instance
    internal let dbi: MDB_dbi

    /// Open a named database in the given transaction.
    internal static func open(transaction: Transaction, name: String? = nil) -> Result<Database, ElephantError> {
        let txn = transaction.handle

        // TODO: Rely on the internals of this (e.g main database and tracked in environment)
        var dbi = MDB_dbi()
        // TODO Use the name
        let err = mdb_dbi_open(txn, nil, 0, &dbi)
        guard err == 0 else {
            return .lmdbError(err)
        }

        return .Success(Database(txn: txn, dbi: dbi))
    }

    /// Associates `data` with the provided `key`. This is a wrapper for `mdb_put`.
    internal func put(key key: ByteBuffer, data: ByteBuffer) -> Result<(), ElephantError> {
        // The key and value buffers aren't modified for a put.
        var keyVal = fromBuffer(key)
        var dataVal = fromBuffer(data)

        let err = mdb_put(txn, dbi, &keyVal, &dataVal, 0)
        guard err == 0 else {
            return .lmdbError(err)
        }

        return .Success()
    }

    /// Retuns the data associated with the provided `key`. This is a wrapper for `mdb_get`.
    internal func get(key: ByteBuffer) -> Result<ByteBuffer, ElephantError> {
        // The key buffer isn't modified for a get.
        var keyVal = fromBuffer(key)
        var dataVal = MDB_val()

        let err = mdb_get(txn, dbi, &keyVal, &dataVal)
        guard err == 0 else {
            return .lmdbError(err)
        }

        let data = unsafeBitCast(dataVal.mv_data, UnsafePointer<UInt8>.self)
        return .Success(ByteBuffer(start: data, count: dataVal.mv_size))
    }

    /// Deletes the `key` and associated `data` from the database. This is a wrapper for `mdb_del`.
    internal func del(key: ByteBuffer) -> Result<(), ElephantError> {
        var keyVal = fromBuffer(key)

        // TODO Support for duplicates (MDB_SORTDUP)
        let err = mdb_del(txn, dbi, &keyVal, nil)
        guard err == 0 else {
            return .lmdbError(err)
        }

        return .Success()
    }
}
