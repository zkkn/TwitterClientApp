//
//  UserRealmDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/26.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import Mapper
import RealmSwift

struct UserRealmDatastore: RealmDatastore {
    
    typealias TargetObject = User
    
    func map(json: NSDictionary, to object: TargetObject, resetRelations: Bool) throws -> TargetObject {
        let map = Mapper(JSON: json)
        
        try object.twitterUserID = map.from("id")
        try object.name = map.from("name")
        try object.screenName = map.from("screen_name")
        try object.profileImageURL = map.from("profile_image_url")
        try object.profileImageURLHTTPS = map.from("profile_image_url_https")
        
        return object
    }
}
