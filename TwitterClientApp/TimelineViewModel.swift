//
//  TimelineViewModel.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/30.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum GetTweetResult {
    case success
    case failed
}

protocol TimelineViewModelInputs {
    var refreshRequest: PublishSubject<Void> { get }
}

protocol TimelineViewModelOutputs {
    var tweets: Variable<[Tweet]> { get }
    var getTweetResult: PublishSubject<GetTweetResult> { get }
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
    
    
    // MARK - Inputs -
    
    let refreshRequest = PublishSubject<Void>()
    
    
    // MARK: - Ouputs -
    
    let tweets = Variable<[Tweet]>([])
    let getTweetResult = PublishSubject<GetTweetResult>()
    
    
    // MARK - Initializers -
    
    init() {
        setBindings()
    }
    
    
    // MARK - Binds -
    
    fileprivate func setBindings() {
        refreshRequest
            .subscribe(onNext: { [weak self] in
                guard let _ = self else { return }
                TweetRepository(
                    apiDatastore: TweetAPIDatastore(),
                    tweetDBDatastore: TweetRealmDatastore(),
                    selfInfoDBDatastore: SelfInfoDatabaseDatastore()
                    )
                    .getTweets(
                        requestNumberOfTweets: 100
                    )
                    .subscribe(
                        onNext: { [weak self] tweets in
                            self?.tweets.value = tweets
                            self?.getTweetResult.onNext(.success)
                        },
                        onError: { [weak self] (error) in
                            print(error)
                            self?.getTweetResult.onNext(.failed)
                    })
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
