//
//  CreateTweetViewModel.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/10.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RxSwift

protocol CreateTweetViewModelInputs {
    var createTweet: PublishSubject<String> { get }
}

protocol CreateTweetViewModelOutputs {
    var createTweetResult: PublishSubject<Bool> { get }
}

protocol CreateTweetViewModelType {
    var inputs: CreateTweetViewModelInputs { get }
    var outputs: CreateTweetViewModelOutputs { get }
}

final class CreateTweetViewModel: CreateTweetViewModelType, CreateTweetViewModelInputs,
CreateTweetViewModelOutputs {
    
    // MARK: - Properties -
    
    var inputs: CreateTweetViewModelInputs { return self }
    var outputs: CreateTweetViewModelOutputs { return self }
    fileprivate var replyTweetID: Int?
    fileprivate let disposeBag = DisposeBag()
    fileprivate let repository: TweetRepositoryType
    
    
     // MARK: - Inputs -
    
    let createTweet = PublishSubject<String>()
    
    // MARK: - Outputs -
    
    let createTweetResult = PublishSubject<Bool>()
    
    
    // MARK - Initializer -
    
    init(repository: TweetRepositoryType, replyTweetID: Int? = nil) {
        self.repository = repository
        self.replyTweetID = replyTweetID
        
        setBindings()
    }
   
    
    // MARK: - Binds -
    
    fileprivate func setBindings() {
        createTweet
            .subscribe(onNext: { [weak self] (tweet) in
                guard let _ = self else { return }
                
                if tweet.isEmpty {
                    self?.createTweetResult.onNext(false)
                }
                else {
                    self?.repository
                        .createTweet(
                            status: tweet,
                            inReplyToStatus: self?.replyTweetID,
                            mediaFlag: nil,
                            latitude: nil,
                            longtitude: nil,
                            placeID: nil,
                            displayCoordinates: nil,
                            trimUser: false,
                            mediaIDs: nil
                        )
                        .subscribe(
                            onNext: { [weak self] (_) in
                                self?.createTweetResult.onNext(true)
                            },
                            onError: { [weak self] (error) in
                                self?.createTweetResult.onNext(false)
                        })
                        .disposed(by: self!.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
}
