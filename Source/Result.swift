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

    /// Helper for consuming a "resource" with transactional semantics.
    internal func transact<U>(consume: T -> Result<U, Error>, commit: T -> Error?, abort: T -> ()) -> Result<U, Error> {
        return flatMap { resource in
            return consume(resource).analysis(
                ifSuccess: { value in
                    if let error = commit(resource) {
                        return .Failure(error)
                    }
                    return Result<U, Error>.Success(value)
                },
                ifFailure: { error in
                    abort(resource)
                    return .Failure(error)
                }
            )
        }
    }
}

internal func lmdbTry<A, B, C>(a: A, _ b: B, _ c: C, _ fn: (A, B, C, UnsafeMutablePointer<COpaquePointer>) -> Int32) -> Result<COpaquePointer, ElephantError> {
    var out: COpaquePointer = nil
    let err = fn(a, b, c, &out)
    return err == 0 ? .Success(out) : .lmdbError(err)
}
