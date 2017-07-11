//
//  UIColor+Extension.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/07/11.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func exBlue() -> UIColor {
        return UIColor(hex: 0x29c1fc, alpha: 0.8)
    }
    
    // initializer
    
    convenience init(hex: Int, alpha: Double) {
        let r = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00ff00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000ff) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}
