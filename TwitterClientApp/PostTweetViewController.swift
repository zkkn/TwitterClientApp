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
    
    fileprivate lazy var headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.leftButton.setTitle("cancel", for: .normal)
        headerView.rightButton.setTitle("tweet", for: .normal)
        return headerView
    }()
    
    fileprivate lazy var tweetTextView: UITextView = UITextView()
    
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
        view.addSubview(tweetTextView)
    }
    
    fileprivate func setConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        tweetTextView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(16)
            make.top.equalTo(headerView.snp.bottom).offset(16)
        }
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
