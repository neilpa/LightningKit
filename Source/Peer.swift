//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import sqlite3

/// Entry point for creating and connecting to a database.
public final class Peer {
    /// Creates a new connection to db at `path`. This this will create
    /// a new database if it doesn't already exist.
    public static func connect(path: String) -> Connection {
        var handle: COpaquePointer = nil
        let code = sqlite3_open(path, &handle)
        return Connection(handle: handle)
    }
}
