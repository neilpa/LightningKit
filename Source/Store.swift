//
//  Store.swift
//  Elephant
//
//  Created by Neil Pankey on 9/18/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import MessagePack
import Result

/// Wrappers for the environment for writing typed data
public final class Store {
    private let env: Environment

    public init(env: Environment) {
        self.env = env
    }

    /// Get a string from the key/value store
    public func get(key: MessagePackValue) -> Result<MessagePackValue, ElephantError> {
        let txn = Transaction.begin(env).value!
        defer { txn.commit() }

        let dbi = Database.open(txn).value!
        return pack(key).withUnsafeBufferPointer { keyBuffer in
            let value = dbi.get(keyBuffer).value!
            let data = NSData(bytes: unsafeBitCast(value.baseAddress, UnsafePointer<Void>.self), length: value.count)
            return try! .Success(unpack(data))
        }
    }

    /// Put a string in the key/value store
    public func put(key: MessagePackValue, _ value: MessagePackValue) -> Result<(), ElephantError> {
        let txn = Transaction.begin(env).value!
        defer { txn.commit() }

        let dbi = Database.open(txn).value!
        return pack(key).withUnsafeBufferPointer { keyBuffer in
        return pack(value).withUnsafeBufferPointer { valueBuffer in
            return dbi.put(key: keyBuffer, data: valueBuffer)
        } }
    }
}
