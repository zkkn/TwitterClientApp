//
//  TwitterAPI.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/18.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import APIKit
import Result
import UIKit

public final class TwitterAPI: Session {
}

protocol TwitterRequestType : Request {
}

extension TwitterRequestType {
    var baseURL: URL {
        return URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!
    }
}

extension TwitterRequestType {
    
    func sendRequest(handler: @escaping (Result<Response, SessionTaskError>) -> Void)
        -> SessionTask? {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            return TwitterAPI.send(self, handler: { result in
                handler(result)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
    }
}
