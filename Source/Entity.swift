//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

/// An associative view of values by attribute key for an entity.
public final class Entity {
    /// The identifier of the entity.
    public let id: Int64

    /// The database that sourced this entity
    public let db: Database

    internal init(id: Int64, db: Database) {
        self.id = id
        self.db = db
    }
}
