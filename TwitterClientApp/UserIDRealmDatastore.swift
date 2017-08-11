//
//  UserIDRealmDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/08/11.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import Mapper

protocol UserIDDatabaseDatastoreType {
    func createOrUpdate(json: Any?, resetRelations: Bool, inTransaction: Bool)
        -> UserIDWithCursor?
}

struct UserIDRealmDatastore: UserIDDatabaseDatastoreType, RealmDatastore {
    
    typealias TargetObject = UserIDWithCursor
    
    func map(json: [String : Any], to object: UserIDWithCursor, resetRelations: Bool) throws -> UserIDWithCursor {
        let map = Mapper(JSON: json as NSDictionary)
        try object.nextCursorString = map.from("next_cursor_string")
        try object.previousCursorString = map.from("previous_cursor_string")
        
        return object
    }
}
