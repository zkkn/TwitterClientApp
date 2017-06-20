//
//  TwitterRequest.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/18.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import APIKit
import Foundation
import OAuthSwift

protocol TwitterRequestType: Request {
}

extension TwitterRequestType {
    
    var baseURL: URL {
        return URL(string: "https://api.twitter.com/1.1")!
    }
    
    var headerFields: [String: String] {
        let defaults = UserDefaults.standard
        if let oauth_token = defaults.string(forKey: "oauth_token") {
            return ["Authorization":TwitterOAuth().createHeaderString(oauth_token: oauth_token)]    
        }
        else {
            return [String:String]()
        }
    }
}
