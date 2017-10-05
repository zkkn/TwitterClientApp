//
//  LikeTweetTimelineViewModel.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/08/20.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol LikeTweetTimelineViewModelInputs {
    var refreshRequest: PublishSubject<Void> { get }
}

protocol LikeTweetTimelineViewModelOutputs {
    var tweets: Variable<[Tweet]> { get }
    var getTweetResult: PublishSubject<Bool> { get }
}

protocol LikeTweetTimelineViewModelType {
    var inputs: LikeTweetTimelineViewModelInputs { get }
    var outputs: LikeTweetTimelineViewModelOutputs { get }
}

final class LikeTweetTimelineViewModel: LikeTweetTimelineViewModelType, LikeTweetTimelineViewModelInputs, LikeTweetTimelineViewModelOutputs {
    
    // MARK - Properties -
    
    var inputs: LikeTweetTimelineViewModelInputs { return self }
    var outputs: LikeTweetTimelineViewModelOutputs { return self }
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
                let defaults = UserDefaults.standard
                guard let selfUserID = try! Realm().object(ofType: SelfInfo.self, forPrimaryKey: defaults.integer(forKey: "userID")) else { return }
                self?.repository
                    .fetchLikeTweets(
                        requestNumberOfTweets: 200,
                        sinceID: nil,
                        maxID: nil,
                        userID: selfUserID,
                        screenName: nil,
                        includeEntities: false)
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
