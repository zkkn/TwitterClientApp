//
//  HeaderView.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/30.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    // MARK - Views -
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("refresh", for: .normal)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    // MARK - Life Cycle Events -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
        setConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Setup -

extension HeaderView {
    
    func setView() {
        addSubview(refreshButton)
    }
    
     func setConstraints() {
        refreshButton.snp.makeConstraints { make in
            make.right.equalTo(self).inset(4)
            make.top.equalTo(self).inset(24)
            make.width.height.equalTo(50)
        }
    }
}
