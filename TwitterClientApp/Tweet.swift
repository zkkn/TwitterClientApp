//
//  Tweet.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/24.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift

final class Tweet: Object {
    
    // MARK: - Properties -
    
    dynamic var id = 0
    dynamic var createdAt = ""
    dynamic var tweetID = 0
    dynamic var text = ""
    dynamic var favoriteCount = 0
    dynamic var favorited = false
    dynamic var user: User?
    let replyTweetID = RealmOptional<Int>()
    let replyUserID = RealmOptional<Int>()
    dynamic var replyScreenName = ""
    
    
    // MARK - Configuration -
    
    override static func primaryKey() -> String? { return "id" }
}
