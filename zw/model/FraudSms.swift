//
//  FraudSms.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/2.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//
import RealmSwift

class FraudSms: Object {
    dynamic var address: String!
    dynamic var to = ""
    dynamic var city = ""
    dynamic var remark = ""
    dynamic var content = ""
    dynamic var createTime = ""
    dynamic var createTimeStr = ""
    dynamic var type = 0
    override class func primaryKey() -> String? {
        return "address"
    }
}
