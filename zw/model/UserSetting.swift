//
//  UserSetting.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/7.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import RealmSwift

class UserSetting: Object {
    dynamic var isAlert = false
    dynamic var isStopCall = false
    dynamic var isStopSms = false
    dynamic var userId = "call110"
    override class func primaryKey() -> String? {
        return "userId"
    }
}
