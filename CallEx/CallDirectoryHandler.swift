//
//  CallDirectoryHandler.swift
//  CallEx
//
//  Created by Zhanqiulin on 2016/12/1.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import Foundation
import CallKit
import RealmSwift

class CallDirectoryHandler: CXCallDirectoryProvider {
    
    // 在打开设置-电话-来电阻止与身份识别开关时，系统自动调用
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
       
        context.delegate = self
        
        do {
            try addBlockingPhoneNumbers(to: context)
        } catch {
            NSLog("Unable to add blocking phone numbers")
            let error = NSError(domain: "CallDirectoryHandler", code: 1, userInfo: nil)
            context.cancelRequest(withError: error)
            return
        }

        context.completeRequest { (t) in
            CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFNotificationName("cn.call110.zw" as CFString), nil, nil, true)
        }
        
    }
    
    // 加入黑名单
    private func addBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) throws {
        // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
//        let phoneNumbers: [CXCallDirectoryPhoneNumber] = [ 14085555555, 18584357333 ]
//        
//        for phoneNumber in phoneNumbers {
//            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
//        }
        
        ZWRealm.shared.query { (realm) in
            let black = realm.objects(BlackPhone.self).filter("type = 1")
            if black.count > 0 {
                black.sorted(byProperty: "phone").forEach({ (e) in
                    context.addBlockingEntry(withNextSequentialPhoneNumber: CXCallDirectoryPhoneNumber.init(e.phone)!)
                })
            } else {
                context.addBlockingEntry(withNextSequentialPhoneNumber: +8612345678901)
            }
            let white = realm.objects(BlackPhone.self).filter("type = 0")
            if white.count > 0 {
                white.sorted(byProperty: "phone").forEach({ (e) in
                    context.addIdentificationEntry(withNextSequentialPhoneNumber: CXCallDirectoryPhoneNumber.init(e.phone)!, label: e.remark)
                })
            } else {
                context.addIdentificationEntry(withNextSequentialPhoneNumber: +8612345678901, label: "测试")
            }
        }
    }
    
    // 标识号码 来电标识
    private func addIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) throws {
        // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        
        let realm = try! Realm()
        realm.objects(BlackPhone.self).sorted(byProperty: "phone").forEach { (e) in
            context.addIdentificationEntry(withNextSequentialPhoneNumber: CXCallDirectoryPhoneNumber.init("+86" + e.phone)!, label: e.remark)
        }
        
//        let phoneNumbers: [CXCallDirectoryPhoneNumber] = [ 18775555555, 18885555555, CXCallDirectoryPhoneNumber.init("+8618584357332")! ]
//        
//        let labels = [ "Telemarketer", "Local business", "骗子校长" ]
//        for (phoneNumber, label) in zip(phoneNumbers, labels) {
//            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
//        }
    }

}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occured while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }

}
