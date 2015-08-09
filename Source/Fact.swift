//
//  Created by Neil Pankey on 8/8/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

/// Minimal representation of novelty about some entity.
public struct Fact {
    /// The entity identifier owning this fact.
    public let entity: Int64

    /// The attribute of the fact (e.g. the key).
    public let attribute: String

    /// The value of the fact.
    public let value: Value

    /// The transaction identifier that generated this fact.
    public let transaction: Int64

    /// Whether the fact was asserted or retracted.
    public let added: Bool
}
