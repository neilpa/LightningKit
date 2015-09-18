//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb
import Result

/// Opaque wrapper for an LMDB database cursor.
public final class Cursor {
    /// The handle to the cursor
    internal let handle: COpaquePointer

    /// Open a cursor to operate against the database.
    internal static func open(database: Database) -> Result<Cursor, ElephantError> {
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
    public func get() -> Result<(ByteBuffer, ByteBuffer), ElephantError> {
        // TODO mdb_cursor_get
        var (keyVal, dataVal) = (MDB_val(), MDB_val())
        mdb_cursor_get(handle, &keyVal, &dataVal, MDB_NEXT)

        let key = ByteBuffer(start: unsafeBitCast(keyVal.mv_data, UnsafePointer<UInt8>.self), count: keyVal.mv_size)
        let data = ByteBuffer(start: unsafeBitCast(dataVal.mv_data, UnsafePointer<UInt8>.self), count: dataVal.mv_size)
        return .Success((key, data))
    }

    private init(handle: COpaquePointer) {
        self.handle = handle
    }

    deinit {
        // TODO?
    }
}