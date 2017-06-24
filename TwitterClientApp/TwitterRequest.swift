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
import RxSwift
import UIKit

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
    

    
    func send() -> Observable<Self.Response> {
        return Session.rx.sendRequest(request: self)
    }
    
    func sendRequest(handler: @escaping (Result<Response, SessionTaskError>) -> Void) -> SessionTask? {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return Session.send(self, handler: { result in
            handler(result)
        })
    }
}
