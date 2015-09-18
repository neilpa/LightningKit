//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb
import Result

/// Opaque wrapper for an LMDB database instance.
public struct Database {
    /// Raw buffers for interfacing with LMDB to defer copies until necessary.
    public typealias ByteBuffer = UnsafeBufferPointer<UInt8>

    /// The handle to the transaction
    internal let txn: COpaquePointer

    /// The wrapped database instance
    internal let dbi: MDB_dbi

    /// Open a named database in the given transaction.
    public static func open(transaction: Transaction, name: String? = nil) -> Result<Database, ElephantError> {
        let txn = transaction.handle

        // TODO: Rely on the internals of this (e.g main database and tracked in environment)
        var dbi = MDB_dbi()
        // TODO Use the name
        let ret = mdb_dbi_open(txn, nil, 0, &dbi)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success(Database(txn: txn, dbi: dbi))
    }

    /// Associates `data` with the provided `key`. This is a wrapper for `mdb_put`.
    public func put(key key: ByteBuffer, data: ByteBuffer) -> Result<(), ElephantError> {
        // The key and value buffers aren't modified for a put.
        var keyVal = MDB_val(mv_size: key.count, mv_data: unsafeBitCast(key, UnsafeMutablePointer<Void>.self))
        var dataVal = MDB_val(mv_size: data.count, mv_data: unsafeBitCast(data, UnsafeMutablePointer<Void>.self))

        let ret = mdb_put(txn, dbi, &keyVal, &dataVal, 0)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success()
    }

    /// Retuns the data associated with the provided `key`. This is a wrapper for `mdb_get`.
    public func get(key: ByteBuffer) -> Result<ByteBuffer, ElephantError> {
        // The key buffer isn't modified for a get.
        var keyVal = MDB_val(mv_size: key.count, mv_data: unsafeBitCast(key, UnsafeMutablePointer<Void>.self))
        var dataVal = MDB_val()

        let ret = mdb_get(txn, dbi, &keyVal, &dataVal)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        let data = unsafeBitCast(dataVal.mv_data, UnsafePointer<UInt8>.self)
        return .Success(ByteBuffer(start: data, count: dataVal.mv_size))
    }

    /// Deletes the `key` and associated `data` from the database. This is a wrapper for `mdb_del`.
    public func del(key: ByteBuffer) -> Result<(), ElephantError> {
        var keyVal = MDB_val(mv_size: key.count, mv_data: unsafeBitCast(key, UnsafeMutablePointer<Void>.self))

        // TODO Support for duplicates (MDB_SORTDUP)
        let ret = mdb_del(txn, dbi, &keyVal, nil)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success()
    }
}
