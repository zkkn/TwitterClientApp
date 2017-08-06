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
    func bulkCreateOrUpdate(json: Any?, resetRelations: Bool, inTransaction: Bool)
        -> [User]?
}

struct UserRealmDatastore: RealmDatastore, UserDatabaseDatastoreType {
    
    typealias TargetObject = User
    
    func map(json: [String : Any], to object: TargetObject, resetRelations: Bool) throws -> TargetObject {
        let map = Mapper(JSON: json as NSDictionary)
        
        try object.twitterUserID = map.from("id")
        try object.name = map.from("name")
        try object.screenName = map.from("screen_name")
        try object.profileImageURL = map.from("profile_image_url")
        try object.profileImageURLHTTPS = map.from("profile_image_url_https")
        return object
    }
}
