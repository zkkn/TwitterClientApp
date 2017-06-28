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
    fileprivate let databaseDatastore: TweetDatabaseDatastoreType
    
    init(apiDatastore: TweetAPIDatastoreType, databaseDatastore: TweetDatabaseDatastoreType) {
        self.apiDatastore = apiDatastore
        self.databaseDatastore = databaseDatastore
    }
    
    func getTweets(requestNumberOfTweets: Int, sinceID: Int?, maxID:Int?, trimUser:Bool, excludeReplies:Bool, includeEntities:Bool)
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
                .map({ (json) in
                    let tweets = self.databaseDatastore
                        .bulkCreateOrUpdate(json: json, resetRelations: true,
                                            inTransaction: false
                        ) 
                    
                    try! Realm().write {
                        // ここでとってきたtweetとselfinfoのtimelineを紐づける処理をかけば良いのだろうか
                    }
                    return tweets!
                })
    }
    
}
