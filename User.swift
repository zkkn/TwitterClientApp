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
    dynamic var name = ""
    dynamic var screenName = ""
    dynamic var profileImageURL = ""
    dynamic var profileImageURLHTTPS = ""
    
    
    // MARK - Configuration -
    
    override static func primaryKey() -> String? { return "id" }
}
