//
//  TempData.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/15.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import RealmSwift

class TempData: Object {
    dynamic var phone: String!
    dynamic var createTime = ""
    dynamic var city = ""
    dynamic var remark = ""
    dynamic var type = 0
    override class func primaryKey() -> String? {
        return "phone"
    }
}
