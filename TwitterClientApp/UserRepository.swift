//
//  UserRepository.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/26.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import Mapper
import RxSwift

protocol UserRespositoryType {
    func getFollowers(userID: Int?, screenName: String?, cursor: Int?, requestNumberOfFollwers: Int?, skipStatus: Bool?, includeEntities: Bool?)
        -> Observable<[User]>
    
    func getFollowersID(userID: Int?, screenName: String?, stringifyIDs: Bool?, requestNumberOfFollwers: Int?)
}

struct UserRespository: UserRespositoryType {
    
    // MARK - Properties -
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let getFollowersIDIncrement = PublishSubject<Int?>()
    let getFollowersIDDatastore = PublishSubject<[String]>()
    
    fileprivate let apiDatastore: UserAPIDatastoreType
    fileprivate let userDBDatastore: UserDatabaseDatastoreType
    fileprivate let selfInfoDBDatastore: SelfInfoDatabaseDatastoreType
    
    // MARK - Initializers -
    
    init(apiDatastore: UserAPIDatastoreType, userDBDatastore: UserDatabaseDatastoreType, selfInfoDBDatastore: SelfInfoDatabaseDatastoreType) {
        self.apiDatastore = apiDatastore
        self.userDBDatastore = userDBDatastore
        self.selfInfoDBDatastore = selfInfoDBDatastore
    }
    
    
    func getFollowers(userID: Int? = nil, screenName: String?, cursor: Int?, requestNumberOfFollwers: Int? = 200, skipStatus: Bool?, includeEntities: Bool? = false)
        -> Observable<[User]> {
            return apiDatastore
                .getFollowers(
                    userID: userID,
                    screenName: screenName,
                    cursor: cursor,
                    requestNumberOfFollwers: requestNumberOfFollwers,
                    skipStatus: skipStatus,
                    includeEntities: includeEntities)
                .map { json in
                    guard let followers = self.userDBDatastore
                        .bulkCreateOrUpdate(
                            json: json["users"],
                            resetRelations: true,
                            inTransaction: false)
                        else {
                            throw RepositoryError.failedToDeserialize
                    }
                    self.selfInfoDBDatastore.setFollowers(followers)
                    return followers
            }
    }
   
    func getFollowersID(userID: Int?, screenName: String?, stringifyIDs: Bool?, requestNumberOfFollwers: Int?) {
        getFollowersIDIncrement.onNext(-1)
        getFollowersIDIncrement.subscribe(onNext: { nextCursor in
            self.apiDatastore
                .getFollowersID(
                    userID: userID,
                    screenName: screenName,
                    cursor: nextCursor,
                    stringifyIDs: stringifyIDs,
                    requestNumberOfFollwers: requestNumberOfFollwers
                )
                .subscribe(onNext: { json in
                    var ids:[String] = []
                    ids.append(json["ids"] as! String)
                    if let nextCursorString = json["next_cursor"] as? String {
                        let nextCursor = Int(nextCursorString)
                        if nextCursor != 0 {
                            self.getFollowersIDIncrement.onNext(nextCursor)
                        }
                        else {
                            self.getFollowersIDDatastore.onNext(ids)
                        }
                    }
                    else {
                        return
                    }
                })
                .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
