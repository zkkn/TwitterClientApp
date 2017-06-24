//
//  TweetAPIDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/24.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

protocol TweetAPIDatastoreType {
    func getTweets(requestNumberOfTweets: Int, sinceID: Int?, maxID:Int?, trimUser:Bool, excludeReplies:Bool, includeEntities:Bool)
        -> Observable<[String: Any]>
}

struct TweetAPIDatastore: TweetAPIDatastoreType {
    
    init() {}
    
    func getTweets(requestNumberOfTweets: Int, sinceID: Int?, maxID: Int?, trimUser: Bool, excludeReplies: Bool, includeEntities: Bool)
        -> Observable<[String : Any]> {
            return TweetRequest
                .GetTweets(requestNumberOfTweets: requestNumberOfTweets, sinceID: sinceID, maxID: maxID)
                .send()
    }
}

fileprivate struct TweetRequest {
    
    fileprivate struct GetTweets: TwitterRequestType {
        
        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> [String:Any] {
            return object as! [String : Any]
        }
        
        let requestNumberOfTweets: Int
        let sinceID: Int?
        let maxID: Int?
        let trimUser = false
        let excludeReplies = true
        let includeEntities = false
        
        let method = HTTPMethod.get
        let path = "statuses/home_timeline.json"
        
        var parameters: Any? {
            var params: [String: Any] = [
                "count": requestNumberOfTweets,
                "trim_user": trimUser,
                "exclude_replies": excludeReplies,
                "include_entities": includeEntities
            ]
            if let sinceID = sinceID {
                params["since_id"] = sinceID
            }
            if let maxID = maxID {
                params["max_id"] = maxID
            }
            return params
        }
    }
}
