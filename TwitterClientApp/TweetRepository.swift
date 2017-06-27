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
        -> Observable<Tweet>
}

struct TweetRepository: TweetRepositoryType {
    
    fileprivate let apiDatastore: TweetAPIDatastoreType
    fileprivate let databaseDatastore: TweetDatabaseDatastoreType
    
    init(apiDatastore: TweetAPIDatastoreType, databaseDatastore: TweetDatabaseDatastoreType) {
        self.apiDatastore = apiDatastore
        self.databaseDatastore = databaseDatastore
    }
    
    func getTweets(requestNumberOfTweets: Int, sinceID: Int?, maxID:Int?, trimUser:Bool, excludeReplies:Bool, includeEntities:Bool)
        -> Observable<Tweet> {
            return apiDatastore
                .getTweets(
                    requestNumberOfTweets: requestNumberOfTweets,
                    sinceID: sinceID,
                    maxID: maxID,
                    trimUser: trimUser,
                    excludeReplies: excludeReplies,
                    includeEntities: includeEntities
                )
                .do(onNext: { (json) in
                    guard let tweet = self.databaseDatastore
                        .createOrUpdate(json: json["object"], resetRelations: true,
                                        inTransaction: false
                        ) else { return }
                    let realm = try! Realm()
                    realm.write {
                        // ここでとってきたtweetとselfinfoのtimelineを紐づける処理をかけば良いのだろうか
                    }
                })
                .map { _ in Tweet() }
    }
    
}
