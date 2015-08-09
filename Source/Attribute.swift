//
//  Created by Neil Pankey on 8/8/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

public struct Attribute {
    /// The entity identifier for the attribute.
    public let id: Int64

    /// The attributes identifier name, including optional namespace.
    public let name: String

    /// The cardinality of the value associated with the attribute.
    public let cardinality: Cardinality
}

/// Specifies whether an attribute associates a single value or set of values.
public enum Cardinality {
    /// A single value.
    case One
    /// A set of values.
    case Many
}
