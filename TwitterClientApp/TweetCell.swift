//
//  TweetCell.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/17.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    // MARK: - Views -
    
    fileprivate lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.hirakakuProNW3(size: 10.0)
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.textColor = .black
        return contentLabel
    }()
    
    
    // MARK: - Initializer -
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Setup -

extension TweetCell {
    
    fileprivate func setViews() {
        addSubview(contentLabel)
    }
    
    fileprivate func setConstraints() {
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(20)
            make.top.equalTo(self).inset(10)
            make.bottom.equalTo(self).inset(30)
        }
    }
}


// MARK: - Update -

extension TweetCell {
    
    func update(tweet: Tweet) {
        contentLabel.text = tweet.text
    }
}
