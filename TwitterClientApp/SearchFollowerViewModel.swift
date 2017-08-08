//
//  SearchFollowerViewModel.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/08/08.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchFollowerViewModelInputs {
    var followerString: PublishSubject<String> { get }
    var refreshFollower: PublishSubject<Void> { get }
    
}

protocol SearchFollowerViewModelOutputs {
    var followers: Variable<[User]> { get }
}

protocol SearchFollowerViewModelType {
    var inputs: SearchFollowerViewModelInputs { get }
    var outputs: SearchFollowerViewModelOutputs { get }
}

final class SearchFollowerViewModel: SearchFollowerViewModelType, SearchFollowerViewModelInputs, SearchFollowerViewModelOutputs {
    
    // MARK - Properties -
    
    var inputs: SearchFollowerViewModelInputs { return self }
    var outputs: SearchFollowerViewModelOutputs { return self }
    fileprivate let disposeBag = DisposeBag()
    fileprivate let repository: UserRespositoryType
    
    
    // MARK - Initializer -
    
    init(repository: UserRespositoryType) {
        self.repository = repository
        
        setBindings()
    }
    
    
    // MARK - Inputs -
    
    let followerString = PublishSubject<String>()
    let refreshFollower = PublishSubject<Void>()
    
    // MARK - Outputs -
    
    let followers = Variable<[User]>([])
    
    
    // MARK - Binds -
    
    fileprivate func setBindings() {
        
    }
}
