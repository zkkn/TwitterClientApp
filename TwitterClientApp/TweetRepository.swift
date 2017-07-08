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
}
