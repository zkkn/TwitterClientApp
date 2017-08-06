//
//  SelfInfoDatabaseDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/29.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift

protocol SelfInfoDatabaseDatastoreType {
    func set(tweets: [Tweet])
    func set(users: [User])
}

struct SelfInfoDatabaseDatastore: SelfInfoDatabaseDatastoreType {
    
    func set(tweets: [Tweet]) {
        let realm = try! Realm()
        try! realm.write {
            let defaults = UserDefaults.standard
            guard let selfInfo = try! Realm().object(ofType: SelfInfo.self, forPrimaryKey: defaults.integer(forKey: "userID")) else { return }
            selfInfo.tweets = List(tweets)
            realm.add(selfInfo, update: true)
        }
    }
    
    func set(users: [User]) {
        let realm = try! Realm()
        try! realm.write {
            let defaults = UserDefaults.standard
            guard let selfInfo = try! Realm().object(ofType: SelfInfo.self, forPrimaryKey: defaults.integer(forKey: "userID")) else { return }
            selfInfo.users = List(users)
            realm.add(selfInfo, update: true)
        }
    }
}
