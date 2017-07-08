//
//  TweetAPIDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/24.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import OAuthSwift
import RxSwift

protocol TweetAPIDatastoreType {
    func getTweets(requestNumberOfTweets: Int, sinceID: Int?, maxID: Int?, trimUser: Bool, excludeReplies: Bool, includeEntities: Bool)
        -> Observable<[[String: Any]]>
}

struct TweetAPIDatastore: TweetAPIDatastoreType {
    
    func getTweets(requestNumberOfTweets: Int, sinceID: Int? = nil, maxID:Int? = nil, trimUser:Bool = false, excludeReplies:Bool = true, includeEntities:Bool = false)
        -> Observable<[[String: Any]]>
    { return
        TweetRequest
            .GetTweets(requestNumberOfTweets: requestNumberOfTweets, sinceID: sinceID, maxID: maxID, trimUser: trimUser, excludeReplies: excludeReplies, includeEntities: includeEntities)
            .sendRequest()
    }
}

fileprivate struct TweetRequest {
    
    fileprivate struct GetTweets {
        
        fileprivate let requestNumberOfTweets: Int
        fileprivate let sinceID: Int?
        fileprivate let maxID: Int?
        fileprivate let trimUser: Bool
        fileprivate let excludeReplies: Bool
        fileprivate let includeEntities: Bool
        
        fileprivate let oauthswift = BuildOAuth1SwiftService.oauthswift
        
        fileprivate var parameters: OAuthSwift.Parameters {
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
        
        fileprivate func sendRequest() -> Observable<[[String: Any]]> {
            return Observable.create { observer in
                self.oauthswift.client.request(
                    "https://api.twitter.com/1.1/statuses/home_timeline.json",
                    method: .GET, parameters: self.parameters, headers: [:],
                    success: { response in
                        let jsonDict = try! response.jsonObject() as? [[String: Any]]
                        observer.onNext(jsonDict!)
                    },
                    failure: { error in
                        observer.onError(error)
                })
                return Disposables.create {
                }
            }
        }
    }
}
