//
//  ViewController.swift
//  LKDemo
//
//  Created by Neil Pankey on 9/19/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import UIKit
import LightningKit
import Result

class ViewController: UICollectionViewController {

    var store: Store! = nil
    var items: [(String, String)] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]

        guard case let .Success(env) = Environment.open(path) else {
            return nil
        }

        store = Store(env: env)
        items = Array(count: env.stat().ms_entries, repeatedValue: ("", ""))

        let item = ("key3", "data3")
        print("putting \(item)")

        items.append(item)
        print("result \(store.put(item))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? items.count : 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        } else {
            return collectionView.dequeueReusableCellWithReuseIdentifier("button", forIndexPath: indexPath)
        }
    }

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            // Delete the tapped item
        } else {
            let item = ("key3", "data3")
            print("putting \(item)")

            items.append(item)
            print("result \(store.put(item))")
        }
    }
}

