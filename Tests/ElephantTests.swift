//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import XCTest
import Elephant
import Result

class ElephantTests: XCTestCase {

    let path = "/tmp/lmdb-test"
    let fs = NSFileManager.defaultManager()

    override func setUp() {
    }

    override func tearDown() {
//        try! fs.removeItemAtPath(path)
    }

    func testConnection() {
        guard case let .Success(env) = Environment.open(path) else {
            XCTAssert(false)
            return
        }

        do {
            guard case let .Success(txn) = Transaction.begin(env) else {
                XCTAssert(false)
                return
            }
            guard case let .Success(dbi) = Database.open(txn) else {
                XCTAssert(false)
                return
            }
            guard case .Success = dbi.put(key: 2, data: 5) else {
                XCTAssert(false)
                return
            }
            guard case .Success = txn.commit() else {
                XCTAssert(false)
                return
            }
        }

        do {
            guard case let .Success(txn) = Transaction.begin(env, readOnly: true) else {
                XCTAssert(false)
                return
            }
            guard case let .Success(dbi) = Database.open(txn) else {
                XCTAssert(false)
                return
            }
            guard case let .Success(value) = dbi.get(2) else {
                XCTAssert(false)
                return
            }
            XCTAssert(value == 5)

            guard case .Success = txn.commit() else {
                XCTAssert(false)
                return
            }
        }
    }
}
