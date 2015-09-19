//
//  Store.swift
//  Elephant
//
//  Created by Neil Pankey on 9/18/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import Result

/// Wrappers for the environment for writing typed data
public final class Store {
    private let env: Environment

    public init(env: Environment) {
        self.env = env
    }

    /// Get a string from the key/value store
    public func get(key: String) -> Result<String, ElephantError> {
        return .Success("")
    }

    /// Put a string in the key/value store
    public func put(key: String, _ value: String) -> Result<(), ElephantError> {
        return .Success()
    }
}
