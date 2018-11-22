//
//  UntilsMacro.swift
//  AddressBook
//
//  Created by useradmin on 2018/11/22.
//  Copyright © 2018年 francis. All rights reserved.
//

import UIKit

let kScreenHeight = UIScreen.main.bounds.height
let kScreenWidth = UIScreen.main.bounds.width
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
let kNavigationHeight = kStatusBarHeight + 44

extension UIDevice{
    public func isIphoneX() -> Bool{
        if kStatusBarHeight > 20 {
            return true
        }else{
            return false
        }
    }
}

