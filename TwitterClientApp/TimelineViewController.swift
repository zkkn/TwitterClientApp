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
    
    fileprivate lazy var headerView: UIView = HeaderView()
    fileprivate lazy var refreshButton: UIButton = HeaderView().refreshButton
    fileprivate lazy var tweetTableView: UITableView  = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(TweetCell.self, forCellReuseIdentifier: "TweetCell")
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }()
    
    fileprivate let scrollView: UIScrollView = {
        return UIScrollView()
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
}


// MARK: - Setup -

extension TimelineViewController {
    
    fileprivate func configure() {
        view.backgroundColor = .white
    }
    
    fileprivate func setViews() {
        view.addSubview(headerView)
        view.addSubview(scrollView)
        scrollView.addSubview(tweetTableView)
    }
    
    fileprivate func setConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(headerView.snp.bottom)
        }
        
        tweetTableView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.bottom.equalTo(scrollView)
        }
    }
    
    fileprivate func subscribeView() {
        refreshButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.viewModel.inputs.refreshRequest.onNext()
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
                switch result {
                case .success:
                    self?.tweetTableView.reloadData()
                    
                case .failed:
                    break
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
