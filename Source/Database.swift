//
//  Database.swift
//  Elephant
//
//  Created by Neil Pankey on 9/13/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import Result

/// Opaque wrapper for an LMDB database.
public struct Database {

    /// Open a named database in the given transaction.
    public func open(txn: Transaction, name: String? = nil) -> Result<Database, ElephantError> {
        return .Success(Database())
    }

}