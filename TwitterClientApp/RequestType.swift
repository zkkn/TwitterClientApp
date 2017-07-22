//
//  RequestType.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/22.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RxSwift
import OAuthSwift

protocol RequestType {
    associatedtype Response
    
    var baseURL: String { get }
    var path: String { get }
    var method: OAuthSwiftHTTPRequest.Method { get }
    var parameters: OAuthSwift.Parameters? { get }
}

extension RequestType {
    var baseURL: String { return "https://api.twitter.com/1.1/" }
    
    func sendRequest() -> Observable<Response> {
        return Observable.create { observer in
            BuildOAuth1SwiftService.oauthswift.client.request(
                self.baseURL + self.path,
                method: self.method,
                parameters: self.parameters!,
                headers: [:],
                success: { response in
                    let jsonDict = try! response.jsonObject() as? Response
                    observer.onNext(jsonDict!)
            },
                failure: { error in
                    observer.onError(error)
            })
            return Disposables.create {
            }
        }
    }
}
