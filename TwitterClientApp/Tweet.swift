//
//  Tweet.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/18.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import RealmSwift
import SnapKit
import UIKit

final class Tweet: Object {
    
    // MARK: - Properties -
    
    dynamic var id = 0
    dynamic var content = ""
    dynamic var isDuplicated = false
    dynamic var isShownInTimeline = true
    dynamic var withOGP = true
    dynamic var createdAt = Date(timeIntervalSince1970: 1)
    dynamic var commentCount = 0
    dynamic var likeCount = 0
    dynamic var myLikeCount = 0
    dynamic var isLocalTweet = false
    let tmpLikeCount = RealmOptional<Int>()
    let tmpMylikeCount = RealmOptional<Int>()
    let userID = RealmOptional<Int>()
    let tweetMedia = List<TweetMedium>()
    let comments = List<Comment>()
}
