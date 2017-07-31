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
    
    func bulkCreateOrUpdate(json: Any?,
                            resetRelations: Bool,
                            inTransaction: Bool) -> [Tweet]?
}

struct TweetRealmDatastore: TweetDatabaseDatastoreType, RealmDatastore {
    
    typealias TargetObject = Tweet
    
    func map(json: [String: Any], to object: TargetObject, resetRelations: Bool) throws -> TargetObject {
        let map = Mapper(JSON: json as NSDictionary)
        try object.createdAt = map.from("created_at")
        try object.favoriteCount = map.from("favorite_count")
        try object.favorited = map.from("favorited")
        try object.text = map.from("text")
        try object.tweetID = map.from("id")
        object.replyTweetID = map.optionalFrom("in_reply_to_status_id") ?? 0
        object.replyUserID = map.optionalFrom("in_reply_to_user_id") ?? 0
        object.replyScreenName = map.optionalFrom("in_reply_to_screen_name")
        
        object.user = UserRealmDatastore()
        .createOrUpdate(json: json["user"], resetRelations: resetRelations, inTransaction: true)
        return object
    }
}
