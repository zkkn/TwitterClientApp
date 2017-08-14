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
    func getFollowersByID(userID: Int?, screenName: String?, isStringifyIDs: Bool?, requestNumberOfFollwers: Int?)
        -> Observable<[User]>
}

struct UserRespository: UserRespositoryType {
    
    // MARK - Properties -
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let apiDatastore: UserAPIDatastoreType
    fileprivate let userDBDatastore: UserDatabaseDatastoreType
    fileprivate let selfInfoDBDatastore: SelfInfoDatabaseDatastoreType
    
    // MARK - Initializers -
    
    init(apiDatastore: UserAPIDatastoreType, userDBDatastore: UserDatabaseDatastoreType, selfInfoDBDatastore: SelfInfoDatabaseDatastoreType) {
        self.apiDatastore = apiDatastore
        self.userDBDatastore = userDBDatastore
        self.selfInfoDBDatastore = selfInfoDBDatastore
    }
    
    func getFollowersByID(userID: Int?, screenName: String?, isStringifyIDs: Bool?, requestNumberOfFollwers: Int?)
        -> Observable<[User]> {
            let getFollowersIDStream = PublishSubject<Int?>()
            let getFollowersAllIDStream = PublishSubject<[Int]>()
            var ids: [Int] = []
            
            return Observable.create { observer in
                getFollowersIDStream.subscribe(onNext: { nextCursor in
                    self.apiDatastore
                        .getFollowersID(
                            userID: userID,
                            screenName: screenName,
                            cursor: nextCursor,
                            isStringifyIDs: isStringifyIDs,
                            requestNumberOfFollwers: requestNumberOfFollwers
                        )
                        .subscribe(onNext: { json in
                            if let nextCursor = json["next_cursor"] as? Int {
                                if nextCursor != 0 {
                                    let jsonIds = json["ids"] as! [Int]
                                    for id in jsonIds {
                                        ids.append(id)
                                    }
                                    getFollowersIDStream.onNext(nextCursor)
                                }
                                else {
                                    getFollowersAllIDStream.onNext(ids)
                                }
                            }
                            else {
                                return
                            }
                        })
                        .disposed(by: self.disposeBag)
                    })
                    .disposed(by: self.disposeBag)
                
                getFollowersIDStream.onNext(-1)
                
                getFollowersAllIDStream.subscribe(onNext: { ids in
                    let idSlice = Array(ids.prefix(100)).map { $0 }
                    let idsDropped = Array(ids.dropFirst(100))
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
                            if idsDropped.count != 0 {
                                getFollowersAllIDStream.onNext(idsDropped)
                            }
                            else {
                                self.selfInfoDBDatastore.setFollowers(followers)
                                observer.onNext(followers)
                            }
                        })
                        .disposed(by: self.disposeBag)
                    })
                    .disposed(by: self.disposeBag)
                
                getFollowersAllIDStream.onNext(ids)
                
                return Disposables.create {
                }
            }
    }
}
