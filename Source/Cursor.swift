//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Result

/// Opaque wrapper for an LMDB database cursor.
public final class Cursor {
    /// The handle to the cursor
    internal let handle: COpaquePointer

    /// Open a cursor to operate against the database.
    public static func open(txn: Transaction, db: Database? = nil) -> Result<Cursor, LightningError> {
        var handle: COpaquePointer = nil
        return mdbTry(mdb_cursor_open(txn.handle, db?.dbi ?? txn.dbi, &handle))
            .map { _ in self.init(handle: handle) }
    }

    /// Position the cursor at the next key. Equivalent `mdb_cursor_get(MDB_NEXT).`
    public func next() -> Result<(ByteBuffer, ByteBuffer), LightningError> {
        return cursorOp(MDB_NEXT)
    }

    /// Position the cursor at the previous key. Equivalent `mdb_cursor_get(MDB_PREV).`
    public func prev() -> Result<(ByteBuffer, ByteBuffer), LightningError> {
        return cursorOp(MDB_PREV)
    }

    /// Position the cursor at the first key. Equivalent `mdb_cursor_get(MDB_FIRST).`
    public func first() -> Result<(ByteBuffer, ByteBuffer), LightningError> {
        return cursorOp(MDB_FIRST)
    }

    /// Position the cursor at the last key. Equivalent `mdb_cursor_get(MDB_LAST).`
    public func last() -> Result<(ByteBuffer, ByteBuffer), LightningError> {
        return cursorOp(MDB_LAST)
    }

    private func cursorOp(op: MDB_cursor_op) -> Result<(ByteBuffer, ByteBuffer), LightningError> {
        // TODO Stupid multi-value out params that are ordered badly
        let err = mdb_cursor_get(handle, &_key, &_data, op)
        if err != 0 {
            return .mdbError(err)
        }

        return .Success((_key.buffer, _data.buffer))
    }

    private init(handle: COpaquePointer) {
        self.handle = handle
    }

    deinit {
        // TODO?
    }

    private var _key = MDB_val()
    private var _data = MDB_val()
}

//
//	MDB_FIRST_DUP,			/**< Position at first data item of current key.
//								Only for #MDB_DUPSORT */
//	MDB_GET_BOTH,			/**< Position at key/data pair. Only for #MDB_DUPSORT */
//	MDB_GET_BOTH_RANGE,		/**< position at key, nearest data. Only for #MDB_DUPSORT */
//	MDB_GET_CURRENT,		/**< Return key/data at current cursor position */
//	MDB_GET_MULTIPLE,		/**< Return key and up to a page of duplicate data items
//								from current cursor position. Move cursor to prepare
//								for #MDB_NEXT_MULTIPLE. Only for #MDB_DUPFIXED */
//	MDB_LAST_DUP,			/**< Position at last data item of current key.
//								Only for #MDB_DUPSORT */
//	MDB_NEXT_DUP,			/**< Position at next data item of current key.
//								Only for #MDB_DUPSORT */
//	MDB_NEXT_MULTIPLE,		/**< Return key and up to a page of duplicate data items
//								from next cursor position. Move cursor to prepare
//								for #MDB_NEXT_MULTIPLE. Only for #MDB_DUPFIXED */
//	MDB_NEXT_NODUP,			/**< Position at first data item of next key */
//	MDB_PREV_DUP,			/**< Position at previous data item of current key.
//								Only for #MDB_DUPSORT */
//	MDB_PREV_NODUP,			/**< Position at last data item of previous key */
//	MDB_SET,				/**< Position at specified key */
//	MDB_SET_KEY,			/**< Position at specified key, return key + data */
//	MDB_SET_RANGE			/**< Position at first key greater than or equal to specified key. */
//
