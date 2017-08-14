//
//  UserRepository.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/26.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RxSwift

protocol UserRespositoryType {
    func getFollowers(userID: Int?, screenName: String?, cursor: Int?, requestNumberOfFollwers: Int?, skipStatus: Bool?, includeEntities: Bool?)
        -> Observable<[User]>
    
    func getFollowersID(userID: Int?, screenName: String?, stringifyIDs: Bool?, requestNumberOfFollwers: Int?)
        -> Observable<[User]>
}

struct UserRespository: UserRespositoryType {
    
    // MARK - Properties -
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let getFollowersIDStream = PublishSubject<Int?>()
    fileprivate let getFollowersIDList = PublishSubject<[Int]>()
    
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
    
    func getFollowersID(userID: Int?, screenName: String?, stringifyIDs: Bool?, requestNumberOfFollwers: Int?)
        -> Observable<[User]> {
            return Observable.create { observer in
                var ids: [Int] = []
                self.getFollowersIDStream.subscribe(onNext: { nextCursor in
                    self.apiDatastore
                        .getFollowersID(
                            userID: userID,
                            screenName: screenName,
                            cursor: nextCursor,
                            stringifyIDs: stringifyIDs,
                            requestNumberOfFollwers: requestNumberOfFollwers
                        )
                        .subscribe(onNext: { json in
                            if let nextCursorString = json["next_cursor"] as? String {
                                let nextCursor = Int(nextCursorString)
                                if nextCursor != 0 {
                                    let jsonIds = json["ids"] as! [Int: String]
                                    for id in jsonIds.map({ Int($0.1)! }) {
                                        ids.append(id)
                                    }
                                    self.getFollowersIDStream.onNext(nextCursor)
                                }
                                else {
                                    self.getFollowersIDList.onNext(ids)
                                }
                            }
                            else {
                                return
                            }
                        })
                        .disposed(by: self.disposeBag)
                    })
                    .disposed(by: self.disposeBag)
                
                self.getFollowersIDStream.onNext(-1)
                
                self.getFollowersIDList.subscribe(onNext: { ids in
                    let idSlice = Array(ids.prefix(100)).map { $0 }
                    let ids = Array(ids.dropFirst(100))
                    self.apiDatastore
                        .getFollowersDetail(
                            screenNames: nil,
                            userID: idSlice,
                            isIncludeEntities: nil)
                        .subscribe(onNext: { json in
                            guard let followers = self.userDBDatastore
                                .bulkCreateOrUpdate(
                                    json: json,
                                    resetRelations: true,
                                    inTransaction: false)
                                else {
                                    return
                            }
                            self.selfInfoDBDatastore.setFollowers(followers)
                            if ids.count != 0 {
                                self.getFollowersIDList.onNext(ids)
                            }
                            else {
                                observer.onNext(followers)
                            }
                        })
                        .disposed(by: self.disposeBag)
                    })
                    .disposed(by: self.disposeBag)
                return Disposables.create {
                }
            }
    }
}
