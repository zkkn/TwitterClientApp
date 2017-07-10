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
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    fileprivate func setViews() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil)
        view.addSubview(tweetTextView)
    }
    
    fileprivate func setConstraints() {
        tweetTextView.snp.makeConstraints { make in
            make.left.right.top.equalTo(view).inset(20)
            make.height.equalTo(250)
        }
    }
    
    fileprivate func subscribeView() {
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                guard let text = self?.tweetTextView.text else { return }
                self?.viewModel.inputs.postTweet.onNext(text)
            })
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
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
