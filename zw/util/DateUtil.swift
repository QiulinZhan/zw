//
//  DateUtil.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/6.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//
import Foundation

public class DateUtil {

    /// 根据传入String时间戳及格式返回格式化之后的String日期
    ///
    /// - parameter timeStamp: 毫秒
    /// - parameter format:    格式 例如 yyyy-MM-dd
    ///
    /// - returns:
    static func timeStampToString(timeStamp: String, format: String) -> String {
        let dateString = NSString(string: timeStamp)
        let timeSta:TimeInterval = dateString.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        let date = NSDate(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date as Date)
    }
    
    /// 获取当前时间戳
    ///
    /// - returns: 当前时间戳 如20160101010101
    static func nowString() -> String {
        let now = Date()
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd"
        return dfmatter.string(from: now)
    }
    
    /// 获取当前时间戳
    ///
    /// - returns: 当前时间戳 如20160101010101
    static func nowStringFormat(format: String) -> String {
        let now = Date()
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        return dfmatter.string(from: now)
    }
    
    /// 格式化时间
    ///
    /// - returns: 当前时间戳 如2016-01-01 10:10:10
    static func format(date: Date, format: String) -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        return dfmatter.string(from: date)
    }
}
