//
//  UserAPIDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/26.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import OAuthSwift
import RxSwift

protocol UserAPIDatastoreType {
    func getFollowers(userID: Int?, screenName: String?, cursor: Int?, requestNumberOfFollwers: Int?, skipStatus: Bool?, includeEntities: Bool?)
        -> Observable<[[String: Any ]]>
}

struct UserAPIDatastore: UserAPIDatastoreType {
    func getFollowers(userID: Int? = nil, screenName: String?, cursor: Int?, requestNumberOfFollwers: Int? = 200, skipStatus: Bool?, includeEntities: Bool? = false)
        ->Observable<[[String: Any]]> { return UserRequest
            .GetFollowers(userID: userID, screenName: screenName, cursor: cursor, requestNumberOfFollwers: requestNumberOfFollwers, skipStatus: skipStatus, includeEntities: includeEntities)
            .sendRequest()
    }
}

fileprivate struct UserRequest {
      fileprivate struct GetFollowers: RequestType {
        typealias Response = [[String: Any]]
        
        fileprivate let userID: Int?
        fileprivate let screenName: String?
        fileprivate let cursor: Int?
        fileprivate let requestNumberOfFollwers: Int?
        fileprivate let skipStatus: Bool?
        fileprivate let includeEntities: Bool?
        
        var path: String { return "followers/list.json" }
        var method: OAuthSwiftHTTPRequest.Method { return .GET }
        var parameters: OAuthSwift.Parameters? {
            var params: [String: Any] = [:]
            
            if let userID = userID {
                params["userID"] = userID
            }
            
            if let screenName = screenName {
                params["screen_name"] = screenName
            }
            
            if let cursor = cursor {
                params["cursor"] = cursor
            }
            
            if let requestNumberOfFollwers = requestNumberOfFollwers {
                params["count"] = requestNumberOfFollwers
            }
            
            if let skipStatus = skipStatus {
                params["skip_status"] = skipStatus
            }
            
            if let includeEntities = includeEntities {
                params["include_user_entities"] = includeEntities
            }
            return params
        }
    }
}
