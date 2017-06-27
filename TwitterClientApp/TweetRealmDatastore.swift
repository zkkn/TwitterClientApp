//
//  TweetRealmDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/26.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import Mapper

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
        
        object.user = UserRealmDatastore()
        .createOrUpdate(json: json["user"], resetRelations: resetRelations, inTransaction: true)
        return object
    }
}
