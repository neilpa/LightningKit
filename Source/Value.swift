//
//  Created by Neil Pankey on 8/8/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

/// Variadic type for the closed set of storeable values.
public enum Value {
    /// Value type for strings.
    case String(Swift.String)

    /// Value type for integers.
    case Int(Int64)
}

/// Protocol for seamless conversion to a storage `Value`.
public protocol ValueConvertible {
    var value: Value { get }
}

extension String: ValueConvertible {
    public var value: Value {
        return .String(self)
    }
}

extension Int: ValueConvertible {
    public var value: Value {
        return .Int(Int64(self))
    }
}
