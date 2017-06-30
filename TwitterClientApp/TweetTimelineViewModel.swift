//
//  TweetTimelineViewModel.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/30.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RxSwift

enum GetTweetResult {
    case success
    case failed
}

protocol TweetTimelineViewModelInputs {
    var refreshRequest: PublishSubject<Void> { get }
}

protocol TweetTimelineViewModelOutputs {
    var getTweetResult: PublishSubject<GetTweetResult> { get }
}

protocol TweetTimelineViewModelType {
    var inputs: TweetTimelineViewModelInputs { get }
    var outputs: TweetTimelineViewModelOutputs { get }
}

final class TweetTimelineViewModel: TweetTimelineViewModelType, TweetTimelineViewModelInputs, TweetTimelineViewModelOutputs {
    
    // MARK - Properties -
    
    var inputs: TweetTimelineViewModelInputs { return self }
    var outputs: TweetTimelineViewModelOutputs { return self }
    fileprivate let disposeBag = DisposeBag()
    
    
    // MARK - Inputs -
    
    let refreshRequest = PublishSubject<Void>()
    
    
    // MARK: - Ouputs -
    
    let getTweetResult = PublishSubject<GetTweetResult>()
    
    
    // MARK - Initializers -
    
    init() {
        setBindings()
    }
    
    
    // MARK - Binds -
    
    fileprivate func setBindings() {
        refreshRequest
            .subscribe(onNext: { [weak self] in
                _ = TweetRepository(apiDatastore: TweetAPIDatastore(), tweetDBDatastore: TweetRealmDatastore(), selfInfoDBDatastore: SelfInfoDatabaseDatastore())
                    .getTweets(requestNumberOfTweets: 100, sinceID: nil, maxID: nil, trimUser: false, excludeReplies: true, includeEntities: false)
                self?.getTweetResult.onNext(.success)
            })
            .disposed(by: disposeBag)
    }
}
