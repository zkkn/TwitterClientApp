//
//  TwitterAPI.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/18.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import APIKit
import Foundation

public final class TwitterAPI: Session {
}

protocol TwitterRequestType: Request {
}

extension TwitterRequestType {
    
    var baseURL: URL {
        return URL(string: "https://api.twitter.com/1.1")!
    }
}
