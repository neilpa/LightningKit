//
//  Created by Neil Pankey on 9/19/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb

/// Raw buffers for interfacing with LMDB values that represent both keys and data.
public typealias ByteBuffer = UnsafeBufferPointer<UInt8>

internal extension MDB_val {
    /// Create an `MDB_val` from a byte buffer.
    internal init(buffer: ByteBuffer) {
        mv_size = buffer.count
        mv_data = unsafeBitCast(buffer.baseAddress, UnsafeMutablePointer<Void>.self)
    }

    /// Extract a byte buffer from an `MDB_val`.
    internal var buffer: ByteBuffer {
        return ByteBuffer(start: unsafeBitCast(mv_data, UnsafePointer<UInt8>.self), count: mv_size)
    }
}
