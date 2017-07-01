//
//  SelfInfoRepository.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/29.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift

protocol SelfInfoRepositoryType {
    static func set()
}

struct SelfInfoRepository: SelfInfoRepositoryType {
    
    static func set() {
        let realm = try! Realm()
        try! realm.write {
            let defaults = UserDefaults.standard
            let selfInfo = SelfInfo()
            realm.add(selfInfo, update: true)
            defaults.set(selfInfo.userID, forKey: "userID")
        }
    }
}
