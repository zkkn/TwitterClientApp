//
//  LoginViewController.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/19.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import OAuthSwift
import RxCocoa
import RxSwift
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
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: LoginViewModelType
    
    
    // MARK: - Initializaer -
    
    init(viewModel: LoginViewModelType) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Life Cycle Events -

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setViews()
        setConstraints()
        subscribeView()
        subscribeViewModel()
    }
}


// MARK: - Setup -

extension LoginViewController {
    
    fileprivate func configure() {
        view.backgroundColor = .white
    }
    
    fileprivate func setViews() {
        view.addSubview(loginButton)
    }
    
    fileprivate func setConstraints() {
        loginButton.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    fileprivate func subscribeView() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let urlHandler = { [weak self] Void -> OAuthSwiftURLHandlerType in
                    if #available(iOS 9.0, *) {
                        let handler = SafariURLHandler(viewController: self!, oauthSwift: BuildAuthorizationService().oauthswift)
                        return handler
                    }
                    return OAuthSwiftOpenURLExternally.sharedInstance
                    }()
                self?.viewModel.inputs.authorizeUser.onNext(urlHandler)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func subscribeViewModel() {
        viewModel.outputs.oauthResult
            .subscribe(onNext: { [weak self] (result) in
                switch result {
                case .success:
                    let alert = UIAlertController(title: "Login Result", message: "Login Success", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    
                case .failed:
                    let alert = UIAlertController(title: "Login Result", message: "Login Failed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}
