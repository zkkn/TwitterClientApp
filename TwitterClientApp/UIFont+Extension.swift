//
//  UIFont+Extension.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/30.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

extension UIFont {
    class func hirakakuProNW3(size: CGFloat) -> UIFont? {
        return UIFont(name: "HirakakuProN-W3", size: size)
    }
    
    class func hirakakuProNW6(size: CGFloat) -> UIFont {
        return UIFont(name: "HirakakuProN-W6", size: size)!
    }
    
    class func gillSans(size: CGFloat) -> UIFont {
        return UIFont(name: "GillSans", size: size)!
    }
}
