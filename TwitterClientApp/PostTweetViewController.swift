//
//  PostTweetViewController.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/10.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class PostTweetViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Views -
    
    fileprivate lazy var headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.leftButton.setTitle("cancel", for: .normal)
        headerView.rightButton.setTitle("tweet", for: .normal)
        return headerView
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView =  UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    fileprivate lazy var tweetTextView: UITextView = {
        let tweetTextView = UITextView()
        tweetTextView.delegate = self
        tweetTextView.font = UIFont.hirakakuProNW3(size: 20)
        return tweetTextView
    }()
    
    fileprivate let keyboardFrameChanged = BehaviorSubject<(frame: CGRect, duration: Double)>(value: (CGRect.zero, 0))
    
    // MARK: - Properties -
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: PostTweetViewModelType
    
    init(viewModel: PostTweetViewModelType) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK - Life Cycle Event -

extension PostTweetViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setViews()
        setConstraints()
        subscribeView()
        subscribeViewModel()
        
        bindView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tweetTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
}


extension PostTweetViewController {
    
    fileprivate func configure() {
        view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func setViews() {
        view.addSubview(headerView)
        view.addSubview(scrollView)
        scrollView.addSubview(tweetTextView)
    }
    
    fileprivate func setConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(headerView.snp.bottom)
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
                self?.viewModel.inputs.postTweet.onNext(text)
            })
            .disposed(by: disposeBag)
        
        headerView.leftButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func subscribeViewModel() {
        viewModel.outputs.postTweetResult
            .subscribe(onNext: { [weak self] (result) in
                if result {
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
                else {
                    self?.showCanNotTweetAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func bindView() {
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

extension PostTweetViewController {
    
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
