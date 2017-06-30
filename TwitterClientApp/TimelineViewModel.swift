//
//  TimelineViewModel.swift
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

protocol TimelineViewModelInputs {
    var refreshRequest: PublishSubject<Void> { get }
}

protocol TimelineViewModelOutputs {
    var getTweet: PublishSubject<[Tweet]> { get }
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
    
    let getTweet = PublishSubject<[Tweet]>()
    let getTweetResult = PublishSubject<GetTweetResult>()
    
    
    // MARK - Initializers -
    
    init() {
        setBindings()
    }
    
    
    // MARK - Binds -
    
    fileprivate func setBindings() {
        refreshRequest
            .subscribe(onNext: { [weak self] in
                TweetRepository(
                    apiDatastore: TweetAPIDatastore(),
                    tweetDBDatastore: TweetRealmDatastore(),
                    selfInfoDBDatastore: SelfInfoDatabaseDatastore()
                    )
                    .getTweets(
                        requestNumberOfTweets: 100
                    )
                    .subscribe(
                        onNext: { [weak self](tweets) in
                            self?.getTweet.onNext(tweets)
                            self?.getTweetResult.onNext(.success)
                        },
                        onError: { error in
                            if let repositoryError = error as? RepositoryError {
                                switch repositoryError {
                                case .notFound:
                                    break
                                default:
                                    self?.getTweetResult.onNext(.failed)
                                }
                            }
                    })
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
