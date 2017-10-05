//
//  TweetCell.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/17.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Kingfisher
import RxSwift
import UIKit

class TweetCell: UITableViewCell {
    
    // MARK: - Views -
    
    fileprivate lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    fileprivate lazy var screenNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gillSans(size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(hex: 0x3a3a3a, alpha: 1.0)
        return label
    }()
    
    fileprivate lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.gillSans(size: 15)
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.textColor = UIColor(hex: 0x3a3a3a, alpha: 1.0)
        return contentLabel
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.setImage(#imageLiteral(resourceName: "ic_balloon_blue_48.png"), for: .normal)
        return button
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
   
    // MARK - Properties -
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer -
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}


// MARK: - Setup -

extension TweetCell {
    
    fileprivate func setViews() {
        self.backgroundColor = UIColor(hex: 0xCECECE, alpha: 1.0)
        
        addSubview(profileImageView)
//        addSubview(nameLabel)
        addSubview(screenNameLabel)
        addSubview(contentLabel)
        addSubview(likeButton)
        addSubview(likeCountLabel)
        addSubview(commentButton)
    }
    
    fileprivate func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.left.top.equalTo(self).inset(8)
            make.width.height.equalTo(50)
        }
        
        screenNameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.top.right.equalTo(self).inset(8)
        }
        
//        screenNameLabel.snp.makeConstraints { make in
//            make.left.equalTo(profileImageView.snp.right).offset(8)
//            make.right.equalTo(self).inset(8)
//            make.top.equalTo(nameLabel.snp.bottom)
//        }
       
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
            make.bottom.equalTo(self).inset(8)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
        }
        
        commentButton.snp.makeConstraints { make in
            make.left.equalTo(likeCountLabel.snp.right).offset(8)
            make.bottom.equalTo(self).inset(8)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.width.height.equalTo(24)
        }
    }
}


// MARK: - Update -

extension TweetCell {
    
    func update(tweet: Tweet) {
        if let profileImageString = tweet.user?.profileImageURLHTTPS {
            profileImageView.kf.setImage(with: URL(string: profileImageString))
        }
        
        contentLabel.text = tweet.text
        likeCountLabel.text = "\(tweet.favoriteCount)"
//        nameLabel.text = tweet.user!.name
        screenNameLabel.text = "@\(tweet.user!.screenName)"
        
        if tweet.favorited {
            likeButton.isSelected = true
        }
        else {
            likeButton.isSelected = false
        }
    }
}
