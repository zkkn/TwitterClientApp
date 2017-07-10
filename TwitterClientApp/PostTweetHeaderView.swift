//
//  PostTweetHeaderView.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/10.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

class PostTweetHeaderView: UIView {
    
    // MARK: - Views -
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("cancel", for: .normal)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var tweetButton: UIButton = {
        let button = UIButton()
        button.setTitle("tweet", for: .normal)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    
    // MARK: - Life Cycle Events -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        configure()
        setView()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Setup -

extension PostTweetHeaderView {
    
    fileprivate func configure() {
        backgroundColor = .red
    }
    
    fileprivate func setView() {
        addSubview(cancelButton)
        addSubview(tweetButton)
    }
    
    fileprivate func setLayout() {
        cancelButton.snp.makeConstraints { make in
            make.left.top.equalTo(self).inset(20)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        tweetButton.snp.makeConstraints { make in
            make.right.top.equalTo(self).inset(20)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
}
