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

final class LoginViewController: UIViewController {
    
    // MARK: - Views -
    
    fileprivate lazy var loginButton: UIButton = {
        let button = UIButton()
        
        // 背景色を設定する.
        button.backgroundColor = UIColor(hex: 0xCECECE, alpha: 1.0)
        
        // 枠を丸くする.
        button.layer.cornerRadius = 20.0
        button.layer.masksToBounds = true
        
        button.setTitle("Login", for: UIControlState.normal)
        button.setTitleColor(UIColor(hex:0x3a3a3a, alpha:1.0), for: UIControlState.normal)
        
        button.titleLabel?.font = UIFont.gillSans(size: 15)
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
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.center.equalTo(view)
            
        }
    }
    
    fileprivate func subscribeView() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let _ = self else { return }
                let URLHandler: OAuthSwiftURLHandlerType
                if #available(iOS 9.0, *) {
                    URLHandler = SafariURLHandler(viewController: self!, oauthSwift: BuildOAuth1SwiftService.oauthswift)
                } else {
                    URLHandler = OAuthSwiftOpenURLExternally.sharedInstance
                }
                self?.viewModel.inputs.authorizeByTwitter.onNext(URLHandler)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func subscribeViewModel() {
        viewModel.outputs.oauthResult
            .subscribe(onNext: { [weak self] (result) in
                switch result {
                case .success:
                    let timelineViewController = TimelineBuilder().build()
                    self?.present(timelineViewController, animated: true, completion: nil)
                    
                case .failed:
                    let alert = UIAlertController(title: "Login Result", message: "Login Failed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}
