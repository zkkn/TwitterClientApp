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
    func getUsers(userID: Int, screenName: Int, includeEntities: Bool) -> Observable<Void>
}

struct UserRespository: UserRespositoryType {
    
    fileprivate let apiDatastore: UserAPIDatastoreType
    fileprivate let databaseDatastore: UserDatabaseDatastoreType
    
    init(apiDatastore: UserAPIDatastoreType, databaseDatastore: UserDatabaseDatastoreType) {
        self.apiDatastore = apiDatastore
        self.databaseDatastore = databaseDatastore
    }
    
    func getUsers(userID: Int, screenName: Int, includeEntities: Bool) -> Observable<Void> {
        return apiDatastore
            .getUsers(
                userID: userID, screenName: screenName, includeEntities: includeEntities
        )
            .do(onNext: { (json) in
                guard let user = self.databaseDatastore.createOrUpdate(json: json["user"], resetRelations: true, inTransaction: false) else {
                    return 
                }
                
                })
                .map { _ in }
    }
}
