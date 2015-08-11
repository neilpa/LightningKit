//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

/// A database connection providing the current state and allowing updates.
public final class Connection {
    /// Returns the current database value.
    public func database() -> Database {
        return Database()
    }

    /// Apply updates to the database.
    public func transact() {
    }
}
