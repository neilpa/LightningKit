//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

/// Errors that can arise.
public enum ElephantError: ErrorType {
    /// Wraps an underlying lmdb error code.
    case LMDBError(Int32)
}
