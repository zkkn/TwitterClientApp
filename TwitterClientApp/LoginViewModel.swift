//
//  LoginViewModel.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/22.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import OAuthSwift
import RxSwift
import UIKit

enum OAuthResult {
    case success
    case failed
}

protocol LoginViewModelInputs {
    var switchOAuthView: PublishSubject<Void> { get }
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
    fileprivate let oauthswift = TwitterOAuth().oauthswift
    
    
    // MARK: - Inputs -
    
    let switchOAuthView = PublishSubject<Void>()
    
    // MARK: - Outputs -
    
    let oauthResult = PublishSubject<OAuthResult>()
    
    
    // MARK: - Initializers -
    
    init() {
        setBindings()
    }
    
    
    // MARK: - Binds -
    
    fileprivate func setBindings() {
        switchOAuthView
            .subscribe(onNext: { [weak self] in
                guard let urlHandler = self?.getURLHandler() else { return }
                self?.oauthswift.authorizeURLHandler = urlHandler
                let _ = self?.oauthswift.authorize(
                    withCallbackURL: URL(string: "TwitterClientApp://oauth-callback")!,
                    success: { [weak self] credential, response, parameters in
                        let defaults = UserDefaults.standard
                        defaults.set(credential.oauthToken, forKey: "oauth_token")
                        defaults.set(credential.oauthTokenSecret, forKey: "oauth_token_secret")
                        self?.oauthResult.onNext(.success)
                    },
                    failure: { error in
                        self?.oauthResult.onNext(.failed)
                })
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func getURLHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 10.0, *) {
            let loginViewController = LoginViewController(viewModel: self)
            let navVC = UINavigationController(rootViewController: loginViewController)
            let handler = SafariURLHandler(viewController: navVC, oauthSwift: oauthswift)
            return handler
        }
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
}
