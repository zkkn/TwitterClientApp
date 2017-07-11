//
//  TimelineViewController.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/17.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class TimelineViewController: UIViewController {
    
    // MARK: - Views -
   
    fileprivate lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.rightButton.setImage(#imageLiteral(resourceName: "ic_pen_white_24.png"), for: .normal)
        return view
    }()
    
    fileprivate lazy var refreshControl = UIRefreshControl()
    
    fileprivate lazy var tweetTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.register(TweetCell.self, forCellReuseIdentifier: "TweetCell")
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
        subscribeView()
        subscribeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.inputs.refreshRequest.onNext()
    }
}


// MARK: - Setup -

extension TimelineViewController {
    
    fileprivate func configure() {
        view.backgroundColor = .white
    }
    
    fileprivate func setViews() {
        view.addSubview(headerView)
        view.addSubview(tweetTableView)
        tweetTableView.addSubview(refreshControl)
    }
    
    fileprivate func setConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalTo(view)
            make.height.equalTo(64)
        }
        
        tweetTableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    fileprivate func subscribeView() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] (_) in
                self?.viewModel.inputs.refreshRequest.onNext()
            })
            .disposed(by: disposeBag)
        
        headerView.rightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let createTweetViewController = CreateTweetBuilder().build()
                self?.present(createTweetViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func subscribeViewModel() {
        viewModel.outputs.tweets.asDriver()
            .drive(onNext: { [weak self] (_) in
                self?.tweetTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.getTweetResult
            .subscribe(onNext: { [weak self] (result) in
                if result {
                    self?.refreshControl.endRefreshing()
                }
                else {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - UITableViewDatasource -

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.tweets.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.update(tweet: viewModel.outputs.tweets.value[indexPath.row])
        
        return cell
    }
}
