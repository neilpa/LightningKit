//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB

/// Packaged errors from different interactions.
public enum LightningError: ErrorType {
    /// File System operation failure.
    case FileSystem(ErrorType)

    /// LMDB operation failure.
    case LMDB(Int32)

    /// Failed to deserialize a binary blob
    case Decode(String)

    /// An unknown error (e.g. throws catchall).
    case Unknown(ErrorType)
}

extension LightningError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .FileSystem(error):
            return "[FileSystem] \(error)"
        case let .LMDB(code):
            return "[LMDB:\(code)] \(mdb_strerror(code))"
        case let .Decode(message):
            return "[Decode] \(message)"
        case let .Unknown(error):
            return "[Unknown] \(error)"
        }
    }
}