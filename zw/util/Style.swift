//
//  Style.swift
//  gfw
//
//  Created by Zhanqiulin on 2016/11/29.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit

extension UIColor {
    static let bgBlack = UIColor(colorValue: "252530", alpha: 1) // 背景黑
    static let bgLightGray = UIColor(colorValue: "CCCCCC", alpha: 1) // 背景浅灰
    static let btnYellow = UIColor(colorValue: "ffae42", alpha: 1) // 按钮黄
    static let btnGreen = UIColor(colorValue: "1fb991", alpha: 1) // 按钮绿
    static let btnRed = UIColor(colorValue: "fb6d50", alpha: 1) // 按钮红
    static let btnBlue = UIColor(colorValue: "009ff2", alpha: 1) // 按钮蓝
    static let bgMask = UIColor(colorValue: "252530", alpha: 0.5) // 按钮蒙版
    static let fontBlack = UIColor(colorValue: "252530", alpha: 1) // 字体颜色黑
    static let fontGray = UIColor(colorValue: "696969", alpha: 1) // 字体颜色灰
    static let lineGray = UIColor(colorValue: "696969", alpha: 0.5) // 字体颜色灰
    static let lightRed = UIColor(red:1.0, green:59/255.0, blue:50/255.0, alpha:1.0) // 亮红色
    convenience init(colorValue: String, alpha: Float) {
        let scanner = Scanner(string: colorValue)
        var valueRGB: UInt32 = 0
        if scanner.scanHexInt32(&valueRGB) {
            self.init(
                colorLiteralRed: Float((valueRGB & 0xFF0000) >> 16) / 255.0,
                green: Float((valueRGB & 0x00FF00) >> 8) / 255.0,
                blue: Float(valueRGB & 0x0000FF) / 255.0,
                alpha: alpha
            )
        } else {
            self.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        }
    }
}
let H1BoldFont = UIFont.boldSystemFont(ofSize: 16) // 字号1粗体
let H1Font = UIFont.systemFont(ofSize: 16) // 字号3
let H2Font = UIFont.systemFont(ofSize: 14) // 字号3
let H3Font = UIFont.systemFont(ofSize: 12) // 字号3
