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

//
//	MDB_FIRST,				/**< Position at first key/data item */
//	MDB_FIRST_DUP,			/**< Position at first data item of current key.
//								Only for #MDB_DUPSORT */
//	MDB_GET_BOTH,			/**< Position at key/data pair. Only for #MDB_DUPSORT */
//	MDB_GET_BOTH_RANGE,		/**< position at key, nearest data. Only for #MDB_DUPSORT */
//	MDB_GET_CURRENT,		/**< Return key/data at current cursor position */
//	MDB_GET_MULTIPLE,		/**< Return key and up to a page of duplicate data items
//								from current cursor position. Move cursor to prepare
//								for #MDB_NEXT_MULTIPLE. Only for #MDB_DUPFIXED */
//	MDB_LAST,				/**< Position at last key/data item */
//	MDB_LAST_DUP,			/**< Position at last data item of current key.
//								Only for #MDB_DUPSORT */
//	MDB_NEXT,				/**< Position at next data item */
//	MDB_NEXT_DUP,			/**< Position at next data item of current key.
//								Only for #MDB_DUPSORT */
//	MDB_NEXT_MULTIPLE,		/**< Return key and up to a page of duplicate data items
//								from next cursor position. Move cursor to prepare
//								for #MDB_NEXT_MULTIPLE. Only for #MDB_DUPFIXED */
//	MDB_NEXT_NODUP,			/**< Position at first data item of next key */
//	MDB_PREV,				/**< Position at previous data item */
//	MDB_PREV_DUP,			/**< Position at previous data item of current key.
//								Only for #MDB_DUPSORT */
//	MDB_PREV_NODUP,			/**< Position at last data item of previous key */
//	MDB_SET,				/**< Position at specified key */
//	MDB_SET_KEY,			/**< Position at specified key, return key + data */
//	MDB_SET_RANGE			/**< Position at first key greater than or equal to specified key. */
//
