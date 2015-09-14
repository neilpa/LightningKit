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

        guard case let .Success(txn) = Transaction.begin(env, readOnly: false) else {
            XCTAssert(false)
            return
        }

        guard case let .Success(dbi) = Database.open(txn) else {
            XCTAssert(false)
            return
        }

        guard case .Success = dbi.put(key: 2, value: 5) else {
            XCTAssert(false)
            return
        }

        guard case .Success = txn.commit() else {
            XCTAssert(false)
            return
        }

//        ret = mdb_txn_begin(env, nil, 0, &txn)
//        XCTAssert(ret == 0)
//
//        ret = mdb_dbi_open(txn, nil, 0, &dbi)
//        XCTAssert(ret == 0)
//
//        var val = -1
//        var get = MDB_val(mv_size: sizeof(Int), mv_data: &val)
//        mdb_get(txn, dbi, &key, &get)
//        XCTAssert(ret == 0)
//        print(NSString(format: "%s", get.mv_data))
//
//        ret = mdb_txn_commit(txn)
//        XCTAssert(ret == 0)
//
//
//        mdb_env_close(env)
    }
}
