//
//  CreateTweetViewController.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/10.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class CreateTweetViewController: UIViewController {
    
    // MARK: - Views -
    
    fileprivate lazy var headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.leftButton.setImage(#imageLiteral(resourceName: "ic_cross_white_40.png"), for: .normal)
        headerView.rightButton.setImage(#imageLiteral(resourceName: "ic_feather"), for: .normal)
        return headerView
    }()
    
    fileprivate lazy var tweetTextView: UITextView = {
        let tweetTextView = UITextView()
        tweetTextView.font = UIFont.hirakakuProNW4(size: 20)
        tweetTextView.textColor = UIColor(hex: 0xF0F1F2, alpha: 1.0)
        if let replyScreenName = self.replyScreenName {
            tweetTextView.text.append("@\(replyScreenName) ")
        }
        return tweetTextView
    }()
    
    
    // MARK: - Properties -
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: CreateTweetViewModelType
    fileprivate let replyScreenName: String?
    fileprivate let keyboardFrameChanged = BehaviorSubject<(frame: CGRect, duration: Double)>(value: (CGRect.zero, 0))
    
    init(viewModel: CreateTweetViewModelType, replyScreenName: String? = nil) {
        self.viewModel = viewModel
        self.replyScreenName = replyScreenName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK - Life Cycle Event -

extension CreateTweetViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setViews()
        setConstraints()
        subscribeView()
        subscribeViewModel()
        subscribeNotificationCenter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tweetTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
}


// MARK - Setup -

extension CreateTweetViewController {
    
    fileprivate func configure() {
        view.backgroundColor = UIColor(hex: 0x1B2936, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func setViews() {
        view.addSubview(headerView)
        view.addSubview(tweetTextView)
    }
    
    fileprivate func setConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalTo(view)
            make.height.equalTo(66)
        }
        
        keyboardFrameChanged
            .subscribe(onNext: { [weak self] (frame, duration) in
                guard let _ = self else { return }
                
                self!.tweetTextView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(self!.view).inset(16)
                    make.top.equalTo(self!.headerView.snp.bottom).offset(16)
                    make.bottom.equalTo(self!.view).inset(frame.height)
                }
                
                UIView.animate(withDuration: duration) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func subscribeView() {
        headerView.rightButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                guard let text = self?.tweetTextView.text else { return }
                self?.viewModel.inputs.createTweet.onNext(text)
            })
            .disposed(by: disposeBag)
        
        headerView.leftButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func subscribeViewModel() {
        viewModel.outputs.createTweetResult
            .subscribe(onNext: { [weak self] (result) in
                if result {
                    self?.dismiss(animated: true, completion: nil)
                }
                else {
                    self?.showCanNotTweetAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func subscribeNotificationCenter() {
        NotificationCenter.default.rx.notification(.UIKeyboardWillShow)
            .subscribe(onNext: { [weak self] (notification) in
                guard
                    let userInfo = notification.userInfo,
                    let infoKey  = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
                    let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
                    else { return }
                
                let keyboardScreenEndFrame = infoKey.cgRectValue
                
                self?.keyboardFrameChanged
                    .onNext((frame: keyboardScreenEndFrame, duration: durationValue))
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.UIKeyboardWillHide)
            .subscribe(onNext: { [weak self] (notification) in
                guard let _ = self else { return }
                guard
                    let beforeDuration = try? self!.keyboardFrameChanged.value().duration
                    else { return }
                
                self?.keyboardFrameChanged
                    .onNext((frame: CGRect.zero, duration: beforeDuration))
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Alert -

extension CreateTweetViewController {
    
    func showCanNotTweetAlert() {
        let alert: UIAlertController = UIAlertController(
            title: "ツイートできないヨ",
            message: "ちゃんと文字を入力したかい？",
            preferredStyle: .alert
        )
        
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK", style: .default, handler: nil
        )
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
}
