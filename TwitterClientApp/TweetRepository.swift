//
//  TweetRepository.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/27.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol TweetRepositoryType {
    func getTweets(requestNumberOfTweets: Int, sinceID: Int?, maxID:Int?, trimUser:Bool, excludeReplies:Bool, includeEntities:Bool)
        -> Observable<[Tweet]>
    
    func createTweet(status: String, inReplyToStatus: Int?, mediaFlag: Bool?, latitude: Float?, longtitude: Float?, placeID: Int?, displayCoordinates: Bool?, trimUser: Bool?, mediaIDs: [Int]?)
        -> Observable<Tweet>
}

struct TweetRepository: TweetRepositoryType {
    
    fileprivate let apiDatastore: TweetAPIDatastoreType
    fileprivate let tweetDBDatastore: TweetDatabaseDatastoreType
    fileprivate let selfInfoDBDatastore: SelfInfoDatabaseDatastoreType
    
    init(apiDatastore: TweetAPIDatastoreType, tweetDBDatastore: TweetDatabaseDatastoreType, selfInfoDBDatastore: SelfInfoDatabaseDatastoreType) {
        self.apiDatastore = apiDatastore
        self.tweetDBDatastore = tweetDBDatastore
        self.selfInfoDBDatastore = selfInfoDBDatastore
    }
    
    func getTweets(requestNumberOfTweets: Int, sinceID: Int? = nil, maxID:Int? = nil, trimUser:Bool = false, excludeReplies:Bool = true, includeEntities:Bool = false)
        -> Observable<[Tweet]> {
            return apiDatastore
                .getTweets(
                    requestNumberOfTweets: requestNumberOfTweets,
                    sinceID: sinceID,
                    maxID: maxID,
                    trimUser: trimUser,
                    excludeReplies: excludeReplies,
                    includeEntities: includeEntities
                )
                .map { json in
                    guard let tweets = self.tweetDBDatastore
                        .bulkCreateOrUpdate(json: json, resetRelations: true, inTransaction: false) else {
                            throw RepositoryError.failedToDeserialize
                    }
                    self.selfInfoDBDatastore.set(tweets: tweets)
                    return tweets
                }
    }
    
    func createTweet(status: String, inReplyToStatus: Int? = nil, mediaFlag: Bool? = nil, latitude: Float? = nil, longtitude: Float? = nil, placeID: Int? = nil, displayCoordinates: Bool? = nil, trimUser: Bool? = nil, mediaIDs: [Int]? = nil)
        -> Observable<Tweet> {
        return apiDatastore
            .createTweet(
                status: status,
                inReplyToStatus: inReplyToStatus,
                mediaFlag: mediaFlag,
                latitude: latitude,
                longtitude: longtitude,
                placeID: placeID,
                displayCoordinates: displayCoordinates,
                trimUser: trimUser,
                mediaIDs: mediaIDs
            )
            .map { json in
                guard let tweet = self.tweetDBDatastore
                    .createOrUpdate(json: json, resetRelations: true, inTransaction: false) else {
                        throw RepositoryError.failedToDeserialize
                }
                return tweet
            }
    }
}
