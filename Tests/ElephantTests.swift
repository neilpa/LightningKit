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
        let result = Environment.open(path)
        guard case let .Success(env) = result else {
            XCTAssert(false)
            return
        }

        let info = env.info()
        let stat = env.stat()

        
//        var txn: COpaquePointer = nil
//        ret = mdb_txn_begin(env, nil, 0, &txn)
//        XCTAssert(ret == 0)
//
//        var dbi = MDB_dbi()
//        ret = mdb_dbi_open(txn, nil, 0, &dbi)
//        XCTAssert(ret == 0)
//
//        var one = 1
//        var key = MDB_val(mv_size: sizeof(Int), mv_data: &one)
//        var two = 2
//        var put = MDB_val(mv_size: sizeof(Int), mv_data: &two)
//        mdb_put(txn, dbi, &key, &put, 0)
//        XCTAssert(ret == 0)
//
//        ret = mdb_txn_commit(txn)
//        XCTAssert(ret == 0)
//
//
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
