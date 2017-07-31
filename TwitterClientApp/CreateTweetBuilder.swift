//
//  CreateTweetBuilder.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/11.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation

struct CreateTweetBuilder {
    
    // MARK - Properties -
    
    fileprivate var replyTweetID: Int?
    
    
    // MARK - Initializer
    
    init(replyTweetID: Int? = nil) {
        self.replyTweetID = replyTweetID
    }
    
    func build() -> CreateTweetViewController {
        let repository = TweetRepository(
            apiDatastore: TweetAPIDatastore(),
            tweetDBDatastore: TweetRealmDatastore(),
            selfInfoDBDatastore: SelfInfoDatabaseDatastore()
        )
        
        let viewModel = CreateTweetViewModel(repository: repository, replyTweetID: replyTweetID)
        
        return CreateTweetViewController(viewModel: viewModel)
    }
}
