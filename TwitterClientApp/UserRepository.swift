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
}

struct UserRespository: UserRespositoryType {
    
    fileprivate let apiDatastore: UserAPIDatastoreType
    fileprivate let databaseDatastore: UserDatabaseDatastoreType
    
    init(apiDatastore: UserAPIDatastoreType, databaseDatastore: UserDatabaseDatastoreType) {
        self.apiDatastore = apiDatastore
        self.databaseDatastore = databaseDatastore
    }
}
