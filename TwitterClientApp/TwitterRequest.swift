//
//  TwitterRequest.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/18.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

protocol TwitterRequestType: Request {
}

extension TwitterRequestType {
    
    var baseURL: URL {
        return URL(string: "https://api.twitter.com/1.1")!
    }
    
    var headerFields: [String: String] {
        let defaults = UserDefaults.standard
        return defaults.dictionary(forKey: "oauthHeaderFieldString") as! [String : String]
    }
}

extension TwitterRequestType {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        guard let response = object as? Self.Response else {
            throw ResponseError.unexpectedObject(object)
        }
        
        return response
    }
}
