//
//  Created by Neil Pankey on 9/19/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb

/// Raw buffers for interfacing with LMDB values that represent both keys and data.
public typealias ByteBuffer = UnsafeBufferPointer<UInt8>

/// Wraps an `MDB_val` buffer in Swift byte buffer
internal func toBuffer(value: MDB_val) -> ByteBuffer {
    return ByteBuffer(start: unsafeBitCast(value.mv_data, UnsafePointer<UInt8>.self), count: value.mv_size)
}

/// Packages a byte buffer into an `MDB_val`.
internal func fromBuffer(buffer: ByteBuffer) -> MDB_val {
    return MDB_val(mv_size: buffer.count, mv_data: unsafeBitCast(buffer.baseAddress, UnsafeMutablePointer<Void>.self))
}
