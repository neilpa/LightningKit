//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import Result
import sqlite3
import Foundation

/// A database connection providing the current state and allowing updates.
public final class Connection {

    /// Connection to the underlying sqlite db.
    private let handle: COpaquePointer

    /// Creates a new connection to db at `path`. This this will create
    /// a new database if it doesn't already exist.
    public static func connect(path: String) -> Result<Connection, ElephantError> {
        var handle: COpaquePointer = nil
        var ret = sqlite3_open(path, &handle)
        guard ret == SQLITE_OK else {
            return .Failure(.SqliteError(ret))
        }

        var ptr: UnsafeMutablePointer<Int8> = nil
        ret = sqlite3_exec(handle, schema, nil, nil, &ptr)
        guard ret == SQLITE_OK else {
            print(NSString(UTF8String: ptr))
            return .Failure(.SqliteError(ret))
        }

        return .Success(Connection(handle: handle))
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

    private static let schema =
        "CREATE TABLE IF NOT EXISTS facts(" +
            "entity_id INTEGER PRIMARY KEY," +
            "attribute STRING NOT NULL," + // TODO attribute_id (and attrs in DB)
            "value BLOB," +
            "transaction_id INTEGER NOT NULL," +
            "added INTEGER NOT NULL" +
        ");"
}
