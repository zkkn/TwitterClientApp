//
//  TimelineBuilder.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/10.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation

struct TimelineBuilder {
    
    init() { }
    
    func build() -> TimelineViewController {
        let repository = TweetRepository(
            apiDatastore: TweetAPIDatastore(),
            tweetDBDatastore: TweetRealmDatastore(),
            selfInfoDBDatastore: SelfInfoDatabaseDatastore()
        )
        
        let viewModel = TimelineViewModel(repository: repository)
        
        return TimelineViewController(
            viewModel: viewModel
        )
    }
}
