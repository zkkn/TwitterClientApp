//
//  Session+Rx.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/24.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import APIKit
import RxSwift

extension Session: ReactiveCompatible {}

extension Reactive where Base: Session {
    
    public func sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = self.base.send(request) { result in
                switch result {
                case .success(let response):
                    observer.on(.next(response))
                    observer.on(.completed)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    public static func sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return Session.shared.rx.sendRequest(request: request)
    }
}
