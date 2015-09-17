//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb
import Result

/// Opaque wrapper for an LMDB database cursor.
public struct Cursor {
    /// The handle to the cursor
    internal let handle: COpaquePointer

    /// Open a cursor to operate against the database.
    public static func open(database: Database) -> Result<Cursor, ElephantError> {
        var handle: COpaquePointer = nil
        let ret = mdb_cursor_open(database.txn, database.dbi, &handle)
        guard ret == 0 else {
            return .Failure(.LMDBError(ret))
        }
        return .Success(Cursor(handle: handle))
    }

    /// Set the cursor at a position
    public func set() {
        // TODO mdb_cursor_set
    }

    /// Get data from the current cursor position
    public func get() {
        // TODO mdb_cursor_get
    }

    private init(handle: COpaquePointer) {
        self.handle = handle
    }
}