//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

/// An immutable database value at a point-in-time.
public final class Database {
    /// Lookup a specific entity by id.
    public func entity(id: Int64) -> Entity {
        return Entity(id: id, db: self)
    }
}
