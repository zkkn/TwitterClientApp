//
//  HeaderView.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/10.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    // MARK: - Views -
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
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

extension HeaderView {
    
    fileprivate func configure() {
        backgroundColor = .red
    }
    
    fileprivate func setView() {
        addSubview(leftButton)
        addSubview(rightButton)
    }
    
    fileprivate func setLayout() {
        leftButton.snp.makeConstraints { make in
            make.left.top.equalTo(self).inset(20)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.top.equalTo(self).inset(20)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
}
