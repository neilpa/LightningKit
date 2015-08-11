//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import Result
import sqlite3

/// A database connection providing the current state and allowing updates.
public final class Connection {

    /// Connection to the underlying sqlite db.
    private var handle: COpaquePointer = nil;

    /// Creates a new connection to db at `path`. This this will create
    /// a new database if it doesn't already exist.
    public static func connect(path: String) -> Result<Connection, ElephantError> {
        var handle: COpaquePointer = nil

        let code = sqlite3_open(path, &handle)
        if code == SQLITE_OK {
            return .Success(Connection(handle: handle))
        } else {
            return .Failure(.SqliteError(code))
        }
    }

    /// Wraps a sqlite connection
    private init(handle: COpaquePointer) {
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
