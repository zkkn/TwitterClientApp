//
//  User.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/24.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift

public final class User: Object {
    
    // MARK - Properties -
    
    public dynamic var id = 0
    public dynamic var twitterUserID = 0
    public dynamic var twitterUserIDStr = ""
    public dynamic var name = ""
    public dynamic var screenName = ""
    public dynamic var URL = ""
    public dynamic var protected = false
    public dynamic var followersCount = 0
    public dynamic var friendsCount = 0
    public dynamic var listedCount = 0
    public dynamic var createdAt = ""
    public dynamic var lang = ""
    public dynamic var profileImageURL = ""
    public dynamic var profileImageURLHTTPS = ""
    public dynamic var following = true
    
    
    // MARK - Configuration -
    
    public override static func primaryKey() -> String? { return "id" }
}
