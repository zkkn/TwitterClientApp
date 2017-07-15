//
//  TweetCell.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/17.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Kingfisher
import UIKit

class TweetCell: UITableViewCell {
    
    // MARK: - Views -
    
    fileprivate lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.hirakakuProNW6(size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    fileprivate lazy var screenNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.hirakakuProNW3(size: 10)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    fileprivate lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.hirakakuProNW3(size: 15)
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.textColor = .black
        return contentLabel
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.setImage(#imageLiteral(resourceName: "ic_heart_pink_32.png"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_heart_pink_48.png"), for: .selected)
        return button
    }()
    
    fileprivate lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.hirakakuProNW3(size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
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
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(screenNameLabel)
        addSubview(contentLabel)
        addSubview(likeButton)
        addSubview(likeCountLabel)
    }
    
    fileprivate func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.left.top.equalTo(self).inset(8)
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.top.right.equalTo(self).inset(8)
        }
        
        screenNameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalTo(self).inset(8)
            make.top.equalTo(nameLabel.snp.bottom)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalTo(self).inset(8)
            make.top.equalTo(screenNameLabel.snp.bottom).offset(8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.bottom.equalTo(self).inset(8)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.width.height.equalTo(24)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.left.equalTo(likeButton.snp.right).offset(8)
            make.right.bottom.equalTo(self).inset(8)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
        }
    }
}


// MARK: - Update -

extension TweetCell {
    
    func update(tweet: Tweet) {
        guard let profileImageString = tweet.user?.profileImageURLHTTPS else { return }
        self.profileImageView.kf.setImage(with: URL(string: profileImageString)!)
        self.screenNameLabel.text = "@" + (tweet.user?.screenName)!
        self.nameLabel.text = tweet.user?.name
        self.contentLabel.text = tweet.text
        self.likeCountLabel.text = "\(tweet.favoriteCount)"
    }
    
    func updateLike() {
        if self.likeButton.isSelected == true {
            self.likeButton.isSelected = false
        }
        else {
            self.likeButton.isSelected = true
        }
    }
}
