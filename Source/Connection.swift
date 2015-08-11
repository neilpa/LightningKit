//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import sqlite3

/// A database connection providing the current state and allowing updates.
public final class Connection {

    /// Connection to the underlying sqlite db.
    private var handle: COpaquePointer = nil;

    /// Wraps a sqlite connection
    internal init(handle: COpaquePointer) {
        self.handle = handle
    }

    /// Close the sqlite connection
    deinit {
        sqlite3_close(handle)
    }

    /// Returns the current database value.
    public func database() -> Database {
        return Database()
    }

    /// Apply updates to the database.
    public func transact() {
    }
}
