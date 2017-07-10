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
}

protocol TimelineViewModelOutputs {
    var tweets: Variable<[Tweet]> { get }
    var getTweetResult: PublishSubject<Bool> { get }
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
    
    
    // MARK: - Ouputs -
    
    let tweets = Variable<[Tweet]>([])
    let getTweetResult = PublishSubject<Bool>()
    
    
    // MARK - Binds -
    
    fileprivate func setBindings() {
        refreshRequest
            .subscribe(onNext: { [weak self] in
                guard let _ = self else { return }
                self?.repository
                    .getTweets(requestNumberOfTweets: 100, sinceID: nil, maxID: nil, trimUser: false, excludeReplies: true, includeEntities: false)
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
    }
}
