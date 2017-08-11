//
//  UserIDWithCursor.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/08/11.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift

final class UserIDWithCursor: Object {
    
    // MARK - Properties -
    
    dynamic var id = 0
    dynamic var ids: UserID?
    dynamic var nextCursorString: String = ""
    dynamic var previousCursor: String = ""
    
    
    // MARK - Configuration -
    
    override static func primaryKey() -> String? { return "id" }
}
