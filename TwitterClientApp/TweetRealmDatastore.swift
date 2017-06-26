//
//  TweetRealmDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/26.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import Mapper
import RealmSwift

protocol TweetDatabaseDatastoreType {
    func createOrUpdate(json: Any?, resetRelations: Bool, inTransaction: Bool)
        -> Tweet?
}

struct TweetRealmDatastore: TweetDatabaseDatastoreType, RealmDatastore {
    
    typealias TargetObject = Tweet
    
    func map(json: NSDictionary, to object: TargetObject, resetRelations: Bool) throws -> TargetObject {
        let map = Mapper(JSON: json)
        try object.createdAt = map.from("created_at")
        try object.favoriteCount = map.from("favorite_count")
        try object.favorited = map.from("favorited")
        try object.source = map.from("source")
        try object.text = map.from("text")
        try object.twitterTweetID = map.from("id")
        
        if let userID = (json["user"] as? NSDictionary)?["id"] as? Int {
            let realm = try! Realm()
            object.user = realm.objects(User.self).filter("id = \(userID)").first
        }
        else {
            object.user = nil
        }
        
        return object
    }
}
