//
//  User.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/24.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift

final class User: Object {
    
    // MARK - Properties -
    
    dynamic var id = 0
    dynamic var twitterUserID = 0
    dynamic var twitterUserIDStr = ""
    dynamic var name = ""
    dynamic var screenName = ""
    dynamic var URL = ""
    dynamic var protected = false
    dynamic var followersCount = 0
    dynamic var friendsCount = 0
    dynamic var listedCount = 0
    dynamic var createdAt = ""
    dynamic var lang = ""
    dynamic var profileImageURL = ""
    dynamic var profileImageURLHTTPS = ""
    dynamic var following = true
    
    
    // MARK - Configuration -
    
    override static func primaryKey() -> String? { return "id" }
}
