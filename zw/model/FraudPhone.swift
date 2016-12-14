//
//  FraudPhone.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/2.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import RealmSwift

class FraudPhone: Object {
    dynamic var phone: String!
    dynamic var city = ""
    dynamic var remark = ""
    dynamic var createTime = ""
    dynamic var type = 0
    dynamic var createTimeStr = ""
    override class func primaryKey() -> String? {
        return "phone"
    }
}
