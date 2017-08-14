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
        -> Observable<[String: Any]>
    
    func getFollowersID(userID: Int?, screenName: String?, cursor: Int?, isStringifyIDs: Bool?, requestNumberOfFollwers: Int?)
        -> Observable<[String: Any]>
    
    func getFollowersDetail(screenNames: [String]?, userID: [Int]?, isIncludeEntities: Bool?)
        -> Observable<[String: Any]>
}

struct UserAPIDatastore: UserAPIDatastoreType {
    func getFollowers(userID: Int? = nil, screenName: String?, cursor: Int?, requestNumberOfFollwers: Int? = 200, skipStatus: Bool?, includeEntities: Bool? = false)
        -> Observable<[String: Any]> { return UserRequest
            .GetFollowers(
                userID: userID,
                screenName: screenName,
                cursor: cursor,
                requestNumberOfFollwers: requestNumberOfFollwers,
                skipStatus: skipStatus,
                includeEntities: includeEntities)
            .sendRequest()
    }
    
    func getFollowersID(userID: Int? = nil, screenName: String?, cursor: Int?, isStringifyIDs: Bool? = false, requestNumberOfFollwers: Int? = 5000)
        -> Observable<[String: Any]> { return UserRequest
            .GetFollowersID(
                userID: userID,
                screenName: screenName,
                cursor: cursor,
                isStringifyIDs: isStringifyIDs,
                requestNumberOfFollwers: requestNumberOfFollwers)
            .sendRequest()
    }
    
    func getFollowersDetail(screenNames: [String]? = nil, userID: [Int]?, isIncludeEntities: Bool? = false)
        -> Observable<[String: Any]> { return UserRequest
            .GetFollowersDetail(
                screenNames: screenNames,
                userID: userID,
                isIncludeEntities: isIncludeEntities)
            .sendRequest()
    }
}

fileprivate struct UserRequest {
      fileprivate struct GetFollowers: RequestType {
        typealias Response = [String: Any]
        
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
    
      fileprivate struct GetFollowersID: RequestType {
        typealias Response = [String: Any]
        
        fileprivate let userID: Int?
        fileprivate let screenName: String?
        fileprivate let cursor: Int?
        fileprivate let isStringifyIDs: Bool?
        fileprivate let requestNumberOfFollwers: Int?
        
        var path: String { return "followers/ids.json" }
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
            
            if let isStringifyIDs = isStringifyIDs {
                params["stringify_ids"] = isStringifyIDs
            }
            return params
        }
    }
    
      fileprivate struct GetFollowersDetail: RequestType {
        typealias Response = [String: Any]
        
        fileprivate let screenNames: [String]?
        fileprivate let userID: [Int]?
        fileprivate let isIncludeEntities: Bool?
        
        var path: String { return "users/lookup.json" }
        var method: OAuthSwiftHTTPRequest.Method { return .POST }
        var parameters: OAuthSwift.Parameters? {
            var params: [String: Any] = [:]
            
            if let userID = userID {
                params["userID"] = userID
            }
            
            if let screenNames = screenNames {
                params["screen_name"] = screenNames
            }
            
            if let isIncludeEntities = isIncludeEntities {
                params["include_user_entities"] = isIncludeEntities
            }
            return params
        }
    }
}
