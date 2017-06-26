//
//  UserAPIDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/26.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

protocol UserAPIDatastoreType {
    static func getUsers(userID: Int, screenName: Int, includeEntities: Bool)
        -> Observable<[String: Any]>
}

struct UserAPIDatastore: UserAPIDatastoreType {
    
    static func getUsers(userID: Int, screenName: Int, includeEntities: Bool)
        -> Observable<[String: Any]> {
            return UserRequest
                .GetUsers(userID: userID, screenName: screenName)
                .send()
    }
}

fileprivate struct UserRequest {
    
    fileprivate struct GetUsers: TwitterRequestType {
        
        let userID: Int
        let screenName: Int
        let includeEntities = false
        
        let method = HTTPMethod.get
        let path = "users/show.json"
        
        var parameters: Any? {
            let params: [String: Any] = [
                "user_id": userID,
                "screen_name": screenName,
                "include_entities": includeEntities
            ]
            return params
        }
        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> [String: Any] {
            return object as! [String: Any]
        }
    }
}
