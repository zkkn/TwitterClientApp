//
//  TimelineViewController.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/17.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

final class TimelineViewController: UIViewController {
    
    // MARK: - Views -
    
    fileprivate lazy var tweetTableView: UITableView  = {
        let tableView = UITableView()
        tableView.register(TweetCell.self, forCellReuseIdentifier: "TweetCell")
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }()
    
    
    // MARK - Properties -
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: TimelineViewModelType
    
    
    // MARK - Initializer -
    
    init(viewModel: TimelineViewModelType) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Life Cycle Events -

extension TimelineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setViews()
        setConstraints()
    }
}


// MARK: - Setup -

extension TimelineViewController {
    
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
