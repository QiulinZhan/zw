//
//  Common.swift
//  gfw
//
//  Created by Zhanqiulin on 2016/11/30.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

//UIView增加点击事件
extension UIView {
    
    func addOnClickListener(target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
}
