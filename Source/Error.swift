//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

/// Errors that can arise.
public enum ElephantError: ErrorType {
    /// Failed to create a directory.
    case CreateDirectoryError(ErrorType)

    /// Wraps an underlying lmdb error code.
    case LMDBError(Int32)
}
