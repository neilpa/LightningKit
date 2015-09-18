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
            "qwer".withCString { qwer in
            "fdsa".withCString { fdsa in
                let qwerB = ByteBuffer(start: unsafeBitCast(qwer, UnsafePointer<UInt8>.self), count: "qwer".utf8.count + 1)
                let fdsaB = ByteBuffer(start: unsafeBitCast(fdsa, UnsafePointer<UInt8>.self), count: "fdsa".utf8.count + 1)
                guard case .Success = dbi.put(key: qwerB, data: fdsaB) else {
                    XCTAssert(false)
                    return
                }
            } }
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
            "qwer".withCString { qwer in
                let qwerB = ByteBuffer(start: unsafeBitCast(qwer, UnsafePointer<UInt8>.self), count: "qwer".utf8.count + 1)
                guard case let .Success(value) = dbi.get(qwerB),
                    let str = String(UTF8String: unsafeBitCast(value.baseAddress, UnsafePointer<Int8>.self))
                    where str == "fdsa" else {
                    XCTAssert(false)
                    return
                }
            }
            guard case .Success = txn.commit() else {
                XCTAssert(false)
                return
            }
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
            guard case let .Success(cursor) = Cursor.open(dbi) else {
                XCTAssert(false)
                return
            }
            while case let .Success(key, data) = cursor.get() where key.count > 0 {
                print(key, data)
            }
            txn.abort()
        }
    }
}
