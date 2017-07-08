//
//  HeaderView.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/30.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    // MARK - Initializer -
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Setup -

extension HeaderView {
    
    func configure() {
        backgroundColor = .red
    }
}
