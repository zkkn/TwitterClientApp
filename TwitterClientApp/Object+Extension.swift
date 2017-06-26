//
//  Object+Extension.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/24.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import RealmSwift

extension Object {
    
    public class var primaryJsonKey: String? {
        return self.primaryKey()
    }
}
