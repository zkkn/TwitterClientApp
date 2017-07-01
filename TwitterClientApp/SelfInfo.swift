//
//  SelfInfo.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/29.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift

final class SelfInfo: Object {
    
    // MARK: - Properties -
    
    dynamic var userID = 0
    dynamic var authHeaderString: String?
    var tweets = List<Tweet>()
    
    
    // MARK - Configuration -
    
    override static func primaryKey() -> String? { return "userID" }
}
