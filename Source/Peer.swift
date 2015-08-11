//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import sqlite3

/// Entry point for creating and connecting to a database.
public final class Peer {
    public static func createDatabase(name: String) {
    }

    public static func connect(name: String) -> Connection {
        return Connection()
    }
}
