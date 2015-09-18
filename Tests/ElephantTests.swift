//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

@testable import Elephant

import XCTest
import Result
import Foundation

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
            guard case let .Success(txn) = Transaction.begin(env, writeable: true) else {
                XCTAssert(false)
                return
            }
            guard case let .Success(dbi) = Database.open(txn) else {
                XCTAssert(false)
                return
            }
//            guard case .Success = dbi.put(key: "qwer".dataUsingEncoding(NSUTF8StringEncoding)!, data: "fdsa".dataUsingEncoding(NSUTF8StringEncoding)!) else {
//                XCTAssert(false)
//                return
//            }
            guard case .Success = txn.commit() else {
                XCTAssert(false)
                return
            }
        }

        do {
            let r = Transaction.begin(env)
            guard case let .Success(txn) = r else {
                XCTAssert(false)
                return
            }
            guard case let .Success(dbi) = Database.open(txn) else {
                XCTAssert(false)
                return
            }
//            guard case let .Success(value) = dbi.get("asdf".dataUsingEncoding(NSUTF8StringEncoding)!),
//                       let str = String(data: value, encoding: NSUTF8StringEncoding) where str == "fdsa" else {
//                XCTAssert(false)
//                return
//            }
            guard case .Success = txn.commit() else {
                XCTAssert(false)
                return
            }
        }

//        do {
//            guard case let .Success(txn) = Transaction.begin(env) else {
//                XCTAssert(false)
//                return
//            }
//            guard case let .Success(dbi) = Database.open(txn) else {
//                XCTAssert(false)
//                return
//            }
//            guard case .Success = dbi.del(2) else {
//                XCTAssert(false)
//                return
//            }
//            guard case .Success = txn.commit() else {
//                XCTAssert(false)
//                return
//            }
//        }
//
//        do {
//            guard case let .Success(txn) = Transaction.begin(env) else {
//                XCTAssert(false)
//                return
//            }
//            guard case let .Success(dbi) = Database.open(txn) else {
//                XCTAssert(false)
//                return
//            }
//            guard case .Failure = dbi.get(2) else {
//                XCTAssert(false)
//                return
//            }
//            txn.abort()
//        }
    }
}
