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

final class PostTweetViewController: UIViewController {
    
    // MARK: - Views -
    
    fileprivate lazy var headerView: PostTweetHeaderView = PostTweetHeaderView()
    
    fileprivate lazy var contentView: UIView = UIView()
    
    fileprivate lazy var tweetTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 3
        return textView
    }()
    
    
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
    }
}


extension PostTweetViewController {
    
    fileprivate func configure() {
        view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func setViews() {
        view.addSubview(headerView)
        view.addSubview(contentView)
        contentView.addSubview(tweetTextView)
    }
    
    fileprivate func setConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(headerView.snp.bottom)
        }
        
        tweetTextView.snp.makeConstraints { make in
            make.left.right.top.equalTo(contentView).inset(20)
            make.height.equalTo(250)
        }
    }
    
    fileprivate func subscribeView() {
        headerView.tweetButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                guard let text = self?.tweetTextView.text else { return }
                self?.viewModel.inputs.postTweet.onNext(text)
            })
            .disposed(by: disposeBag)
        
        headerView.cancelButton.rx.tap
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
