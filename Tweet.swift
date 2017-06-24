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
    dynamic var twitterTweetID = 0
    dynamic var twitterTweetIDStr = ""
    dynamic var text = ""
    dynamic var source = ""
    dynamic var favoriteCount = 0
    dynamic var favorited = false
    dynamic var lang = ""
    let user = List<User>()
    
    
    // MARK - Configuration -
    
    override static func primaryKey() -> String? { return "id" }
}
