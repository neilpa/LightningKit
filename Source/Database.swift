//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import Result
import lmdb

/// Opaque wrapper for an LMDB database.
public struct Database {
    private let txn: COpaquePointer
    private let dbi: MDB_dbi

    /// Open a named database in the given transaction.
    public static func open(transaction: Transaction, name: String? = nil) -> Result<Database, ElephantError> {
        let txn = transaction.txn

        var dbi = MDB_dbi()
        // TODO Use the name
        let ret = mdb_dbi_open(txn, nil, 0, &dbi)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success(Database(txn: txn, dbi: dbi))
    }

    public func put(var key key: Int, var value: Int) -> Result<(), ElephantError> {
        var keyData = MDB_val(mv_size: sizeof(Int), mv_data: &key)
        var valueData = MDB_val(mv_size: sizeof(Int), mv_data: &value)

        let ret = mdb_put(txn, dbi, &keyData, &valueData, 0)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }

        return .Success()
    }
}