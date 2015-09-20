//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Result

/// Opaque wrapper for an LMDB database instance.
public struct Database {
    /// Open the default database
    public static func open(txn: Transaction) -> Result<Database, LightningError> {
        var dbi = MDB_dbi()
        return mdbTry(mdb_dbi_open(txn.handle, nil, 0, &dbi))
            .map { _ in self.init(dbi: dbi, env: txn.env) }
    }

    /// Open a named database in the given transaction.
    public static func open(txn: Transaction, name: String) -> Result<Database, LightningError> {
        var dbi = MDB_dbi()
        return mdbTry(mdb_dbi_open(txn.handle, name, 0, &dbi))
            .map { _ in self.init(dbi: dbi, env: txn.env) }
    }

    /// The environment owning this database.
    let env: Environment

    /// The wrapped database instance
    internal let dbi: MDB_dbi

    internal init(dbi: MDB_dbi, env: Environment) {
        self.dbi = dbi
        self.env = env
    }
}
