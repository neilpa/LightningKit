//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import Result
import lmdb

/// Opaque wrapper for an LMDB database.
public struct Database {
    /// The handle to the transaction
    private let txn: COpaquePointer

    /// The wrapped database instance
    private let dbi: MDB_dbi

    /// Open a named database in the given transaction.
    public static func open(transaction: Transaction, name: String? = nil) -> Result<Database, ElephantError> {
        let txn = transaction.handle

        var dbi = MDB_dbi()
        // TODO Use the name
        let ret = mdb_dbi_open(txn, nil, 0, &dbi)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success(Database(txn: txn, dbi: dbi))
    }

    public func put(var key key: Int, var data: Int) -> Result<(), ElephantError> {
        var keyVal = MDB_val(mv_size: sizeof(Int), mv_data: &key)
        var dataVal = MDB_val(mv_size: sizeof(Int), mv_data: &data)

        let ret = mdb_put(txn, dbi, &keyVal, &dataVal, 0)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success()
    }

    public func get(var key: Int) -> Result<Int, ElephantError> {
        var keyVal = MDB_val(mv_size: sizeof(Int), mv_data: &key)
        var dataVal = MDB_val()

        let ret = mdb_get(txn, dbi, &keyVal, &dataVal)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        // TODO Need some safeguards here...
        return .Success(UnsafeMutablePointer<Int>(dataVal.mv_data).memory)
    }
}
