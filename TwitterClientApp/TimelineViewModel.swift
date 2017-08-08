//
//  TimelineViewModel.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/30.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RxSwift

protocol TimelineViewModelInputs {
    var refreshRequest: PublishSubject<Void> { get }
    var likeTweet: PublishSubject<Int> { get }
    var deleteLikeTweet: PublishSubject<Int> { get }
}

protocol TimelineViewModelOutputs {
    var tweets: Variable<[Tweet]> { get }
    var getTweetResult: PublishSubject<Bool> { get }
    var likeTweetResult: PublishSubject<Int?> { get }
}

protocol TimelineViewModelType {
    var inputs: TimelineViewModelInputs { get }
    var outputs: TimelineViewModelOutputs { get }
}

final class TimelineViewModel: TimelineViewModelType, TimelineViewModelInputs, TimelineViewModelOutputs {
    
    // MARK - Properties -
    
    var inputs: TimelineViewModelInputs { return self }
    var outputs: TimelineViewModelOutputs { return self }
    fileprivate let disposeBag = DisposeBag()
    fileprivate let repository: TweetRepositoryType
    
    
    // MARK - Initializer -
    
    init(repository: TweetRepositoryType) {
        self.repository = repository
        
        setBindings()
    }
    
    
    // MARK - Inputs -
    
    let refreshRequest = PublishSubject<Void>()
    let likeTweet = PublishSubject<Int>()
    let deleteLikeTweet = PublishSubject<Int>()
    
    
    // MARK: - Ouputs -

    let tweets = Variable<[Tweet]>([])
    let getTweetResult = PublishSubject<Bool>()
    let likeTweetResult = PublishSubject<Int?>()
    
    
    // MARK - Binds -
    
    fileprivate func setBindings() {
        refreshRequest
            .subscribe(onNext: { [weak self] in
                guard let _ = self else { return }
                self?.repository
                    .getTweets(requestNumberOfTweets: 100, sinceID: nil, maxID: nil, trimUser: false, excludeReplies: false, includeEntities: false)
                    .subscribe(
                        onNext: { [weak self] tweets in
                            self?.tweets.value = tweets
                            self?.getTweetResult.onNext(true)
                        },
                        onError: { [weak self] (error) in
                            self?.getTweetResult.onNext(false)
                    })
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
        
        likeTweet
            .subscribe(onNext: { [weak self] id in
                guard let _ = self else { return }
                self?.repository
                    .likeTweet(
                        tweetID: id,
                        includeEntities: nil
                    )
                    .subscribe(
                        onNext: { [weak self] (_) in
                            self?.likeTweetResult.onNext(id)
                        },
                        onError: { [weak self] (error) in
                            self?.likeTweetResult.onNext(nil)
                    })
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
        
        deleteLikeTweet
            .subscribe(onNext: { [weak self] id in
                guard let _ = self else { return }
                self?.repository
                    .deleteLikeTweet(
                        tweetID: id,
                        includeEntities: nil
                    )
                    .subscribe(
                        onNext: { [weak self] (_) in
                            self?.likeTweetResult.onNext(id)
                        },
                        onError: { [weak self] (error) in
                            self?.likeTweetResult.onNext(nil)
                    })
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
