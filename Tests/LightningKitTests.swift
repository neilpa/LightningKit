//
//  Created by Neil Pankey on 8/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

@testable import LightningKit

import XCTest
import Result
import Foundation

class LightningKitTests: XCTestCase {

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
            "qwer".withByteBuffer { qwer in
            "fdsa".withByteBuffer { fdsa in
                guard case .Success = txn.put(key: qwer, data: fdsa) else {
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
            "qwer".withByteBuffer { qwer in
                guard case let .Success(value) = txn.get(qwer),
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
            guard case let .Success(cursor) = Cursor.open(txn) else {
                XCTAssert(false)
                return
            }
            while case let .Success(key, data) = cursor.next() where key.count > 0 {
                print(key, data)
            }
            while case let .Success(key, data) = cursor.prev() where key.count > 0 {
                print(key, data)
            }
            let r = cursor.last()
            guard case let .Success(key, data) = r else {
                XCTAssert(false)
                return
            }
            print(key, data)
            txn.abort()
        }
    }
}
