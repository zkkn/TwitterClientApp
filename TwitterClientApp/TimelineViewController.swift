//
//  TimelineViewController.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/17.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import DGElasticPullToRefresh
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
        tableView.backgroundColor = UIColor(hex: 0xCECECE, alpha: 1.0)
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.register(TweetCell.self, forCellReuseIdentifier: "TweetCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(hex: 0xCECECE, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.viewModel.inputs.refreshRequest.onNext()
            tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(hex: 0x3a3a3a, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
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
    
    deinit {
        tweetTableView.dg_removePullToRefresh()
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
        let tweetID = viewModel.outputs.tweets.value[indexPath.row].tweetID
        cell.update(tweet: viewModel.outputs.tweets.value[indexPath.row])
       
        cell.likeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let tweet = self?.viewModel.outputs.tweets.value[indexPath.row] else { return }
                if tweet.favorited {
                    self?.viewModel.inputs.deleteLikeTweet.onNext(tweetID)
                }
                else {
                    self?.viewModel.inputs.likeTweet.onNext(tweetID)
                }
            })
            .disposed(by: cell.disposeBag)
        
        cell.commentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let tweet = self?.viewModel.outputs.tweets.value[indexPath.row] else { return }
                let createTweetViewController = CreateTweetBuilder(replyTweetID: tweet.tweetID, replyScreenName: tweet.user?.screenName).build()
                self?.present(createTweetViewController, animated: true, completion: nil)
            })
            .disposed(by: cell.disposeBag)
    
        viewModel.outputs.likeTweetResult
            .subscribe(onNext: { [weak self] (id) in
                if id == tweetID {
                    guard let tweet = self?.viewModel.outputs.tweets.value[indexPath.row] else { return }
                    cell.update(tweet: tweet)
                }
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
}
