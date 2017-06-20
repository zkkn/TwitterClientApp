//
//  LoginViewController.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/19.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import OAuthSwift
import SnapKit
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Views -
    
    fileprivate lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Twitter OAuth", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        return button
    }()
    
    
    // MARK: - Properties -
    
    var oauthswift: OAuthSwift?
   
    fileprivate lazy var consumerData: [String: String] = {
        return TwitterOAuth().consumerData
    }()
}


// MARK: - Life Cycle Events -

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginButton.addTarget(self, action: #selector(doOAuthTwitter), for: .touchUpInside)
    }
}


// MARK: - Setup -

extension LoginViewController {
    
    func setViews() {
        view.backgroundColor = .white
        view.addSubview(loginButton)
    }
    
    func setConstraints() {
        loginButton.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
}


// MARK: - OAuth -

extension LoginViewController {
    
    func doOAuthTwitter() {
        let oauthswift = OAuth1Swift(
            consumerKey:    consumerData["consumerKey"]!,
            consumerSecret: consumerData["consumerSecret"]!,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = getURLHandler()
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "TwitterClientApp://oauth-callback")!,
            success: { [weak self] credential, response, parameters in
                self?.showTokenAlert(credential: credential)
                let defaults = UserDefaults.standard
                defaults.setValue(credential.oauthToken, forKey: "oauth_token")
            },
            failure: { error in
                print(error.description)
        }
        )
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 10.0, *) {
            let handler = SafariURLHandler(viewController: self, oauthSwift: oauthswift!)
            return handler
        }
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
}


// MARK: - Show Alert View -

extension LoginViewController {
    
    func showTokenAlert(credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauthToken)"
        if !credential.oauthTokenSecret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauthTokenSecret)"
        }
        showAlertView(message: message)
    }
    
    func showAlertView(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
