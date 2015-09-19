//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import MessagePack

/// Errors that can arise.
public enum ElephantError: ErrorType {
    /// Failed to create a directory.
    case CreateDirectoryError(ErrorType)

    /// Wraps an underlying lmdb error code.
    case LMDBError(Int32)

    /// Wraps a MessagePack serialization failure
    case MessagePack(MessagePackError)

    /// An unknown error (blame throws)
    case Unknown(ErrorType)
}
