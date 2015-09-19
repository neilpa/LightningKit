//
//  Created by Neil Pankey on 9/19/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import MessagePack
import Result

internal extension Result {
    /// Convenience function for wrapping an LMDB error.
    internal static func lmdbError(code: Int32) -> Result<T, ElephantError> {
        return .Failure(.LMDB(code))
    }

    /// Convenience function for wrapping a file system error.
    internal static func fsError(error: ErrorType) -> Result<T, ElephantError> {
        return .Failure(.FileSystem(error))
    }

    /// Convenience function for wrapping a MessagePack error.
    internal static func msgPackError(error: MessagePackError) -> Result<T, ElephantError> {
        return .Failure(.MessagePack(error))
    }
}
