//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import lmdb
import MessagePack

/// Packaged errors from different interactions.
public enum ElephantError: ErrorType {
    /// File System operation failure.
    case FileSystem(ErrorType)

    /// LMDB operation failure.
    case LMDB(Int32)

    /// MessagePack serialization failure.
    case MessagePack(MessagePackError)

    /// An unknown error (e.g. throws catchall).
    case Unknown(ErrorType)
}

extension ElephantError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .FileSystem(error):
            return "[FileSystem] \(error)"
        case let .LMDB(code):
            return "[LMDB:\(code)] \(mdb_strerror(code))"
        case let .MessagePack(error):
            return "[MessagePack] \(error)"
        case let .Unknown(error):
            return "[Unknown] \(error)"
        }
    }
}