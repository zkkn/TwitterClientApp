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
}

struct UserRespository: UserRespositoryType {
    
    fileprivate let apiDatastore: UserAPIDatastoreType
    fileprivate let userDBDatastore: UserDatabaseDatastoreType
    fileprivate let selfInfoDBDatastore: SelfInfoDatabaseDatastoreType
    
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
                    includeEntities: includeEntities
                )
                .map { json in
                    guard let followers = self.userDBDatastore
                        .bulkCreateOrUpdate(
                            json: json["users"],
                            resetRelations: true,
                            inTransaction: false
                        )
                        else
                        {
                            throw RepositoryError.failedToDeserialize
                        }
                    self.selfInfoDBDatastore.set(followers: followers)
                    return followers
            }
    }
}
