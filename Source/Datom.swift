//
//  Created by Neil Pankey on 8/8/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

/// An immutable, point-in-time fact.
public struct Datom {
    /// The entity identifier of the "subject" of the datom.
    public let entity: Int64

    /// The entity identifier of the attribute of the datom.
    public let attribute: Int64

    /// The value associated with the attribute of the datom.
    public let value: Value

    /// The transaction identifier that committed the datom.
    public let transaction: Int64

    /// Whether the datom is an assertion or retraction.
    public let added: Bool
}
