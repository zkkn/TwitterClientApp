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
    static func set(tweets: [Tweet])
}

struct SelfInfoDatabaseDatastore: SelfInfoDatabaseDatastoreType {
    
    static func set(tweets: [Tweet]) {
        let defaults = UserDefaults.standard
        guard let selfInfo = try! Realm().object(ofType: SelfInfo.self, forPrimaryKey: defaults.dictionary(forKey: "userID")) else { return }
        selfInfo.tweets = List(tweets)
        
        try! Realm().add(selfInfo, update: true)
    }
}
