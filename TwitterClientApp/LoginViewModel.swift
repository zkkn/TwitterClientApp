//
//  LoginViewModel.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/22.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import OAuthSwift
import RxSwift

enum OAuthResult {
    case success
    case failed
}

protocol LoginViewModelInputs {
    var authorizeByTwitter: PublishSubject<OAuthSwiftURLHandlerType> { get }
}

protocol LoginViewModelOutputs {
    var oauthResult: PublishSubject<OAuthResult> { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

final class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
    
    // MARK: - Properties -
    
    var inputs: LoginViewModelInputs { return self }
    var outputs: LoginViewModelOutputs { return self }
    fileprivate let disposeBag = DisposeBag()
    fileprivate let oauthswift = BuildOAuth1SwiftService.oauthswift
    
    
    // MARK: - Inputs -
    
    let authorizeByTwitter = PublishSubject<OAuthSwiftURLHandlerType>()
    
    // MARK: - Outputs -
    
    let oauthResult = PublishSubject<OAuthResult>()
    
    
    // MARK: - Initializers -
    
    init() {
        setBindings()
    }
    
    
    // MARK: - Binds -
    
    fileprivate func setBindings() {
        authorizeByTwitter
            .subscribe(onNext: { [weak self] (urlHandler) in
                self?.oauthswift.authorizeURLHandler = urlHandler
                _ = self?.oauthswift.authorize(
                    withCallbackURL: URL(string: "TwitterClientApp://oauth-callback")!,
                    success: { [weak self] credential, response, parameters in
                        self?.saveCredentials(credential)
                        self?.oauthResult.onNext(.success)
                    },
                    failure: { error in
                        self?.oauthResult.onNext(.failed)
                })
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Save Credentials -
    
    fileprivate func saveCredentials(_ credential: OAuthSwiftCredential) {
        let defaults = UserDefaults.standard
        defaults.set(credential.oauthToken, forKey: "oauth_token")
        defaults.set(credential.makeHeaders(URL(string: "https://api.twitter.com/1.1")!, method: OAuthSwiftHTTPRequest.Method(rawValue: "POST")!, parameters: [:]), forKey: "oauthHeaderFieldString")
    }
}
