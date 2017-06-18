//
//  TwitterRequest.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/18.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import APIKit
import Foundation
import Result

var RequestCount = 0

protocol TwitterRequestType: Request {
}

extension TwitterRequestType {
    
    var baseURL: URL {
        return URL(string: "https://api.twitter.com/1.1")!
    }
    
    var headerFields: [String: String] {
        let accessToken = ""
        if accessToken == "2430218185-ONyS4zOJlWOZ8E1qtUm4D1YKV8uG3oJtHCDW3kH" {
            return ["Authorization": "Bearer \(accessToken)"]
        }
        else {
            return [String: String]()
        }
    }
}
