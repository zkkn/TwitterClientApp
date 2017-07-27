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
    
    func createTweet(status: String, inReplyToStatus: Int?, mediaFlag: Bool?, latitude: Float?, longtitude: Float?, placeID: Int?, displayCoordinates: Bool?, trimUser: Bool?, mediaIDs: [Int]?)
        -> Observable<[String: Any]>
    
    func likeTweet(tweetID: Int, includeEntities: Bool?)
        -> Observable<[String: Any]>
    
    func deleteLikeTweet(tweetID: Int, includeEntities: Bool?)
        -> Observable<[String: Any]>
}

struct TweetAPIDatastore: TweetAPIDatastoreType {
    
    func getTweets(requestNumberOfTweets: Int, sinceID: Int? = nil, maxID:Int? = nil, trimUser:Bool = false, excludeReplies:Bool = false, includeEntities:Bool = false)
        -> Observable<[[String: Any]]> { return TweetRequest
            .GetTweets(requestNumberOfTweets: requestNumberOfTweets, sinceID: sinceID, maxID: maxID, trimUser: trimUser, excludeReplies: excludeReplies, includeEntities: includeEntities)
            .sendRequest()
    }
    
    func createTweet(status: String, inReplyToStatus: Int?, mediaFlag: Bool?, latitude: Float?, longtitude: Float?, placeID: Int?, displayCoordinates: Bool?, trimUser: Bool?, mediaIDs: [Int]?)
        -> Observable<[String : Any]> { return TweetRequest
            .CreateTweet(status: status, inReplyToStatusID: inReplyToStatus, mediaFlag: mediaFlag, latitude: latitude, longtitude: longtitude, placeID: placeID, displayCoordinates: displayCoordinates, trimUser: trimUser, mediaIDs: mediaIDs)
            .sendRequest()
    }
    
    func likeTweet(tweetID: Int, includeEntities: Bool?) -> Observable<[String : Any]> {
        return TweetRequest
        .LikeTweet(tweetID: tweetID, includeEntities: includeEntities)
        .sendRequest()
    }
    
    func deleteLikeTweet(tweetID: Int, includeEntities: Bool?) -> Observable<[String : Any]> {
        return TweetRequest
        .DeleteLikeTweet(tweetID: tweetID, includeEntities: includeEntities)
        .sendRequest()
    }
}



fileprivate struct TweetRequest {
    
    fileprivate struct GetTweets: RequestType {
        typealias Response = [[String: Any]]
        
        fileprivate let requestNumberOfTweets: Int
        fileprivate let sinceID: Int?
        fileprivate let maxID: Int?
        fileprivate let trimUser: Bool
        fileprivate let excludeReplies: Bool
        fileprivate let includeEntities: Bool
        
        var path: String { return "statuses/home_timeline.json" }
        var method: OAuthSwiftHTTPRequest.Method { return .GET }
        var parameters: OAuthSwift.Parameters? {
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
    
    fileprivate struct CreateTweet: RequestType {
        typealias Response = [String: Any]
        
        fileprivate let status: String
        fileprivate let inReplyToStatusID: Int?
        fileprivate let mediaFlag: Bool?
        fileprivate let latitude: Float?
        fileprivate let longtitude: Float?
        fileprivate let placeID: Int?
        fileprivate let displayCoordinates: Bool?
        fileprivate let trimUser: Bool?
        fileprivate let mediaIDs: [Int]?
        
        var path: String { return "statuses/update.json" }
        var method: OAuthSwiftHTTPRequest.Method { return .POST }
        fileprivate var parameters: OAuthSwift.Parameters? {
            var params: [String: Any] = [
                "status": status
            ]
            if let inReplyToStatusID = inReplyToStatusID {
                params["in_reply_to_status_id"] = inReplyToStatusID
            }
            if let mediaFlag = mediaFlag {
                params["possibly_sensitive"] = mediaFlag
            }
            if let latitude = latitude {
                params["lat"] = latitude
            }
            if let longtitude = longtitude {
                params["long"] = longtitude
            }
            if let placeID = placeID {
                params["place_ID"] = placeID
            }
            if let displayCoordinates = displayCoordinates {
                params["display_coordinates"] = displayCoordinates
            }
            if let trimUser = trimUser {
                params["trime_user"] = trimUser
            }
            if let mediaIDs = mediaIDs {
                params["media_ids"] = mediaIDs
            }
            return params
        }
    }
    
    fileprivate struct LikeTweet: RequestType {
        typealias Response = [String: Any]
        
        fileprivate let tweetID: Int
        fileprivate let includeEntities: Bool?
        
        var path: String { return "favorites/create.json" }
        var method: OAuthSwiftHTTPRequest.Method { return .POST }
        fileprivate var parameters: OAuthSwift.Parameters? {
            var params: [String: Any] = [
                "id": tweetID
            ]
            if let includeEntities = includeEntities {
                params["include_entities"] = includeEntities
            }
            return params
        }
    }
    
    fileprivate struct DeleteLikeTweet: RequestType {
        typealias Response = [String: Any]
        
        fileprivate let tweetID: Int
        fileprivate let includeEntities: Bool?
        
        var path: String { return "favorites/destroy.json" }
        var method: OAuthSwiftHTTPRequest.Method { return .POST }
        fileprivate var parameters: OAuthSwift.Parameters? {
            var params: [String: Any] = [
                "id": tweetID
            ]
            if let includeEntities = includeEntities {
                params["include_entities"] = includeEntities
            }
            return params
        }
    }
}
