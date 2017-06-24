//
//  Tweet.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/24.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift

public final class Tweet : Object {
    
    // MARK: - Properties -
    
    public dynamic var id = 0
    public dynamic var createdAt = ""
    public dynamic var twitterTweetID = 0
    public dynamic var twitterTweetIDStr = ""
    public dynamic var text = ""
    public dynamic var source = ""
    public dynamic var favoriteCount = 0
    public dynamic var favorited = false
    public dynamic var lang = ""
    public let user = List<User>()
    
    
    // MARK - Configuration -
    
    public override static func primaryKey() -> String? { return "id" }
}
