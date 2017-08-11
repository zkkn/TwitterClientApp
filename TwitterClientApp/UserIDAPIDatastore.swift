//
//  UserIDAPIDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/08/11.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import OAuthSwift
import RxSwift

protocol UserIDAPIDatastoreType {
    func getFollowersID(userID: Int?, screenName: String?, cursor: Int?, stringifyIDs: Bool?, requestNumberOfFollwers: Int?)
        -> Observable<[String: Any]>
}

struct UserIDAPIDatastore: UserIDAPIDatastoreType {
    func getFollowersID(userID: Int? = nil, screenName: String?, cursor: Int?, stringifyIDs: Bool? = false, requestNumberOfFollwers: Int? = 5000)
        ->Observable<[String: Any]> { return UserIDRequest
            .GetFollowersID(userID: userID, screenName: screenName, cursor: cursor, stringifyIDs: stringifyIDs, requestNumberOfFollwers: requestNumberOfFollwers)
            .sendRequest()
        }
    }

fileprivate struct UserIDRequest {
      fileprivate struct GetFollowersID: RequestType {
        typealias Response = [String: Any]
        
        fileprivate let userID: Int?
        fileprivate let screenName: String?
        fileprivate let cursor: Int?
        fileprivate let stringifyIDs: Bool?
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
            
            if let stringifyIDs = stringifyIDs {
                params["stringify_ids"] = stringifyIDs
            }
            return params
        }
    }
}
