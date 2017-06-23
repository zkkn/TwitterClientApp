//
//  TweetTimelineViewController.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/17.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import SnapKit
import UIKit

final class TweetTimelineViewController: UIViewController {
    
    // MARK: - Views -
    
    fileprivate lazy var tweetTableView: UITableView  = {
        let tableView = UITableView()
        tableView.register(TweetCell.self, forCellReuseIdentifier: "TweetCell")
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }()
}


// MARK: - Life Cycle Events -

extension TweetTimelineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setViews()
        setConstraints()
    }
}


// MARK: - Setup -

extension TweetTimelineViewController {
    
    fileprivate func configure() {
        view.backgroundColor = .white
    }
    
    fileprivate func setViews() {
        view.addSubview(tweetTableView)
    }
    
    fileprivate func setConstraints() {
        tweetTableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}
