//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import Result

/// Opaque wrapper for an LMDB transaction.
public struct Transaction {
    private let txn: COpaquePointer

    /// Start a new transaction in the given `environment`.
    public static func begin(environment: Environment, readOnly: Bool) -> Result<Transaction, ElephantError> {
        return .Success(self.init(txn: nil))
    }

    public func commit() -> Result<(), ElephantError> {
        return .Success()
    }

    public func abort() {
    }

    private init(txn: COpaquePointer) {
        self.txn = txn
    }
}
