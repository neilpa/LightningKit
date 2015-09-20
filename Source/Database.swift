//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Result

/// Opaque wrapper for an LMDB database instance.
public struct Database {
    /// The wrapped database instance
    internal let dbi: MDB_dbi

    /// Open the default database
    internal static func open(txn: COpaquePointer) -> Result<Database, LightningError> {
        return lmdbTry(txn, nil, 0, mdb_dbi_open).map(self.init)
    }

    /// Open a named database in the given transaction.
    internal static func open(txn: COpaquePointer, name: String) -> Result<Database, LightningError> {
        return lmdbTry(txn, name, 0, mdb_dbi_open).map(self.init)
    }
}
