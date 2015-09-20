//
//  Created by Neil Pankey on 9/19/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Result

internal extension Result {
    /// Inject effects, generally for resource cleanup. The `success` case can optionally
    /// return an `Error` to convert a succesful result into a failure if a "commit" fails.
    internal func on(success success: T -> Error? = { _ in nil }, failure: Error -> () = { _ in }) -> Result {
        return analysis(
            ifSuccess: { value in
                if let error = success(value) {
                    return .Failure(error)
                }
                return .Success(value)
            },
            ifFailure: { error in
                failure(error)
                return .Failure(error)
            }
        )
    }
}

internal func mdbTry(errorCode: Int32) -> Result<(), LightningError> {
    return errorCode == 0 ? .Success() : .Failure(.LMDB(errorCode))
}
