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
    
    fileprivate lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.hirakakuProNW6(size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    fileprivate lazy var screenNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.hirakakuProNW3(size: 10)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    fileprivate lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.hirakakuProNW3(size: 10)
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
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(screenNameLabel)
        addSubview(contentLabel)
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
            make.right.bottom.equalTo(self).inset(8)
            make.top.equalTo(screenNameLabel.snp.bottom).offset(8)
        }
    }
}


// MARK: - Update -

extension TweetCell {
    
    func update(tweet: Tweet) {
        let downloadTask = URLSession.shared.dataTask(with: URL(string: (tweet.user?.profileImageURLHTTPS)!)!) {
            [weak self] (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self?.profileImageView.image = UIImage(data: data!)
            }
        }
        downloadTask.resume()
        
        self.screenNameLabel.text = "@" + (tweet.user?.screenName)!
        self.nameLabel.text = tweet.user?.name
        self.contentLabel.text = tweet.text
    }
}
