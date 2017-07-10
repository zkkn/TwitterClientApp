//
//  PostTweetViewModel.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/10.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RxSwift

protocol PostTweetViewModelInputs {
    var postTweet: PublishSubject<String> { get }
}

protocol PostTweetViewModelOutputs {
    var postTweetResult: PublishSubject<Bool> { get }
}

protocol PostTweetViewModelType {
    var inputs: PostTweetViewModelInputs { get }
    var outputs: PostTweetViewModelOutputs { get }
}

final class PostTweetViewModel: PostTweetViewModelType, PostTweetViewModelInputs,
PostTweetViewModelOutputs {
    
    // MARK: - Properties -
    
    var inputs: PostTweetViewModelInputs { return self }
    var outputs: PostTweetViewModelOutputs { return self }
    fileprivate let disposeBag = DisposeBag()
    fileprivate let repository: TweetRepositoryType
    
    
    // MARK - Initializer -
    
    init(repository: TweetRepositoryType) {
        self.repository = repository
        
        setBindings()
    }
    
    // MARK: - Inputs -
    
    let postTweet = PublishSubject<String>()
    
    // MARK: - Outputs -
    
    let postTweetResult = PublishSubject<Bool>()
    
    
    // MARK: - Binds -
    
    fileprivate func setBindings() {
        postTweet
            .subscribe(onNext: { [weak self] tweet in
                guard let _ = self else { return }
                
                if tweet.isEmpty {
                    self?.postTweetResult.onNext(false)
                }
                else {
                    self?.repository
                        .postTweet(status: tweet, inReplyToStatus: nil, mediaFlag: nil, latitude: nil, longtitude: nil, placeID: nil, displayCoordinates: nil, trimUser: nil, mediaIDs: nil)
                        .subscribe(
                            onNext: { [weak self] (_) in
                                self?.postTweetResult.onNext(true)
                            },
                            onError: { [weak self] (error) in
                                self?.postTweetResult.onNext(false)
                        })
                        .disposed(by: self!.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
}
