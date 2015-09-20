//
//  Created by Neil Pankey on 9/19/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Result

internal extension Result {
    /// Inject effects without changing the result.
    internal func on(success success: T -> () = { _ in }, failure: Error -> () = { _ in }) -> Result {
        return analysis(
            ifSuccess: { value in
                success(value)
                return .Success(value)
            },
            ifFailure: { error in
                failure(error)
                return .Failure(error)
            }
        )
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

internal func mdbTry(errorCode: Int32) -> Result<(), LightningError> {
    return errorCode == 0 ? .Success() : .Failure(.LMDB(errorCode))
}
