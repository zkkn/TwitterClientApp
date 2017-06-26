//
//  UserRealmDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/26.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import Mapper

protocol UserDatabaseDatastoreType {
}

struct UserRealmDatastore: RealmDatastore, UserDatabaseDatastoreType {
    
    typealias TargetObject = User
    
    func map(json: NSDictionary, to object: TargetObject, resetRelations: Bool) throws -> TargetObject {
        
        return object
    }
}
