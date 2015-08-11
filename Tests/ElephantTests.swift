//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import XCTest
import Elephant

class ElephantTests: XCTestCase {

    func testConnection() {
        XCTAssertNotNil(Connection.connect(":memory:").value)
    }

}
