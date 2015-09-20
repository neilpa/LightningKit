//
//  Created by Neil Pankey on 9/18/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import LMDB
import Foundation
import Result

/// Wrappers for the environment for writing typed data
public final class Store {
    private let env: Environment

    public init(env: Environment) {
        self.env = env
    }

    public func dump() -> Result<[(String, String)], LightningError> {
        return Environment.query(env.handle) { txn in
            let values: [(String, String)] = []
            return .Success(values)
        }
    }

    /// Get a string from the key/value store
    public func get(key: String) -> Result<String, LightningError> {
        let txn = Transaction.begin(env).value!
        defer { txn.commit() }

        let dbi = Database.open(txn).value!
        return key.withUnsafeBufferPointer { keyBuffer in
            let value: ByteBuffer = dbi.get(keyBuffer).value!
            let string = String(bytes: value, encoding: NSUTF8StringEncoding)
            return string.map(Result.Success) ?? .Failure(.Decode(""))
        }
    }

    /// Put a string in the key/value store
    public func put(key: String, _ value: String) -> Result<(), LightningError> {
        let txn = Transaction.begin(env, writeable: true).value!
        defer { txn.commit() }

        let dbi = Database.open(txn).value!
        return key.withUnsafeBufferPointer { keyBuffer in
        return value.withUnsafeBufferPointer { valueBuffer in
            return dbi.put(key: keyBuffer, data: valueBuffer)
        } }
    }
}

internal extension String {
    internal func withUnsafeBufferPointer<T>(f: UnsafeBufferPointer<UInt8> -> T) -> T {
        return withCString {
            return f(ByteBuffer(start: unsafeBitCast($0, UnsafePointer<UInt8>.self), count: utf8.count))
        }
    }
}
