//
//  PhoneViewController.swift
//  gfw
//
//  Created by Zhanqiulin on 2016/12/1.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD
import CallKit
import Alamofire
import SwiftyJSON

class PhoneViewController: UIViewController {
    var alertSwitch: SwitchBar! // 识来电开关
    var phoneSwitch: SwitchBar! // 防骚扰开关
    var userSetting: UserSetting!
    var settingView: UIView!
    var vc: HelpViewController!
    let notifiName = "cn.call110.zw" as CFString
    let manager = CXCallDirectoryManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "识来电"
        view.backgroundColor = UIColor.bgLightGray
        alertSwitch = SwitchBar(title: "识来电", frame: CGRect.zero)
        view.addSubview(alertSwitch)
        alertSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.right.equalTo(view).offset(0)
            make.height.equalTo(50)
        }
        alertSwitch.iswitch.addTarget(self, action: #selector(switchChange), for: .valueChanged)
        phoneSwitch = SwitchBar(title: "防骚扰", frame: CGRect.zero)
        view.addSubview(phoneSwitch)
        phoneSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(alertSwitch.snp.bottom).offset(1)
            make.left.right.equalTo(view).offset(0)
            make.height.equalTo(50)
        }
//        phoneSwitch.switchChange = { sender in
//            RealmUtil.update({ (realm) in
//                self.userSetting.isStopCall = sender.isOn
//            })
//        }
        loadData()
        ZWRealm.shared.query { (realm) in
            self.userSetting = realm.object(ofType: UserSetting.self, forPrimaryKey: "call110")
            self.alertSwitch.iswitch.isOn = self.userSetting.isAlert
            self.phoneSwitch.iswitch.isOn = self.userSetting.isStopCall
            print("str1" + realm.objects(BlackPhone.self).map({ (e) -> String in
                return e.phone
            }).joined(separator: ","))
            print("str2" + realm.objects(TempData.self).map({ (e) -> String in
                return e.phone
            }).joined(separator: ","))
        }
        
        checkPermissions()
//        { (_, observer, name, _, _) -> Void in
//            if let observer = observer, let name = name {
//                
//                // Extract pointer to `self` from void pointer:
//                let mySelf = Unmanaged<YourClass>.fromOpaque(observer).takeUnretainedValue()
//                // Call instance method:
//                mySelf.callback(name.rawValue as String)
//            }
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque()), { (_, observer, name, _, _) in
            let mySelf = Unmanaged<PhoneViewController>.fromOpaque(observer!).takeUnretainedValue()
            mySelf.checkPassed()
        }, notifiName, nil, CFNotificationSuspensionBehavior.deliverImmediately)
    }
    
    // 加载远程数据
    func loadData() {
        Alamofire.request("http://192.168.1.107:8092/zw/p/getblackphone").validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                let data = result["data"].arrayValue.map({ (obj) -> TempData in
                    let phone = TempData()
                    phone.createTime = obj["createTime"].stringValue
                    phone.city = obj["city"].stringValue
                    phone.phone = obj["phone"].stringValue
                    phone.remark = obj["remark"].stringValue
                    phone.type = obj["type"].intValue
                    return phone
                })
                ZWRealm.shared.query(action: { (realm) in
                    try! realm.write {
                        let old = realm.objects(TempData.self)
                        if old.count > 0 {
                            realm.delete(old)
                        }
                        if data.count > 0 {
                            realm.add(data, update: false)
                        }
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 通知处理
    func notificationHandle(notice: Notification) {
        guard let data = notice.userInfo as? [String: Any] else {
            return
        }
        if let type = data["type"] as? String {
            print(type)
            if type == "yellowpage" {
                if let status = data["status"] as? CXCallDirectoryManager.EnabledStatus {
                    switch status {
                    case .enabled:
                        checkPassed()
                    default:
                        gotoSetting()
                    }
                }
            } else if type == "yellow_ok" {
                checkPassed()
            }
        }
    }
    
    deinit {
        //注意由于通知是单例的，所以用了之后需要析构，
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque()), CFNotificationName(rawValue: notifiName), nil)
    }
    
    func checkPassed() {
        if vc != nil {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    // 去设置
    func gotoSetting() {
        vc = HelpViewController()
        present(vc, animated: true) {
            self.cancelAll()
        }
    }
    
    /// 提示框
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: {
            completion?()
        })
    }
    
    func cancelAll() {
        alertSwitch.iswitch.isOn = false
        phoneSwitch.iswitch.isOn = false
        ZWRealm.shared.query { (realm) in
            let obj = realm.object(ofType: UserSetting.self, forPrimaryKey: "call110")
            let results = realm.objects(BlackPhone.self)
            try! realm.write {
                obj?.isAlert = false
                obj?.isStopCall = false
                realm.delete(results)
            }
        }
    }
    
//    func updateData(_ reload: @escaping (_ data: Results<FraudPhone>) -> Void) {
//        SVProgressHUD.show()
//        RealmUtil.query { (realm) in
//            self.dataList = realm.objects(FraudPhone.self).sorted(byProperty: "createTime", ascending: false)
//            reload(self.dataList)
//            SVProgressHUD.dismiss()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 检查权限
    func checkPermissions(enabled: (() -> Void)? = nil) {
        SVProgressHUD.show()
        manager.getEnabledStatusForExtension(withIdentifier: "cn.call110.zw.CallEx", completionHandler: {(status, error) in

            if error == nil {
                switch status {
                case .enabled:
                    self.checkPassed()
                    enabled?()
                    print(1)
                case .unknown:
                    print(2)
                    self.showAlert(title: "系统错误", message: "请重装应用", completion: { 
                        self.cancelAll()
                    })
                default:
                    self.gotoSetting()
                }
            } else {
                print(error.debugDescription)
            }
            
            SVProgressHUD.dismiss()
        })
        
    }
    
//    switch status {
//    case .unknown:
//    print("1")
//    case .disabled:
//    print("2")
//    case .enabled:
//    enabled(status)
//    }
    
    func switchChange(sender: UISwitch) {
        checkPermissions {
            ZWRealm.shared.query(action: { (realm) in
                try! realm.write {
                    let old = realm.objects(BlackPhone.self)
                    if old.count > 0 {
                        realm.delete(old)
                    }
                    let user = realm.object(ofType: UserSetting.self, forPrimaryKey: "call110")
                    if sender.isOn {
                        let list = realm.objects(TempData.self).map({ (t) -> BlackPhone in
                            let black = BlackPhone()
                            black.phone = "+86" + t.phone
                            black.remark = t.remark
                            black.type = t.type
                            return black
                        })
                        realm.add(list, update: false)
                        user?.isAlert = true
                        user?.isStopCall = true
                    } else {
                        user?.isAlert = false
                        user?.isStopCall = false
                    }
                    
                }
            })
            self.manager.reloadExtension(withIdentifier: "cn.call110.zw.CallEx", completionHandler: { (error) in
                if error == nil {
                    
                } else {
                    self.cancelAll()
                }
            })
        }
        
//        if sender == phoneSwitch.iswitch {
//            if userSetting.isStopCall {
//                RealmUtil.update({ (realm) in
//                    self.userSetting.isStopCall = false
//                })
//            } else {
//                checkPermissions({ (status) in
//                    switch status {
//                    case .unknown:
//                        self.showAlert(title: "系统错误", message: "请重装应用", sender: sender)
//                    case .disabled:
//                        self.showAlert(title: "请开启设置开关", message: "请前往\"系统设置-电话-来电\n阻止与身份识别\"开启\"拦骚\n扰\"开关", sender: sender)
//                    case .enabled:
//                        RealmUtil.update({ (realm) in
//                            self.userSetting.isStopCall = true
//                        })
//                    }
//                })
//            }
//        } else {
//            if userSetting.isAlert {
//                let realm = try! Realm()
//                try! realm.write {
//                    self.userSetting.isAlert = false
//                }
//            } else {
//                checkPermissions({ (status) in
//                    switch status {
//                    case .unknown:
//                        self.showAlert(title: "系统错误", message: "请重装应用", sender: sender)
//                    case .disabled:
//                        self.showAlert(title: "请开启设置开关", message: "请前往\"系统设置-电话-来电\n阻止与身份识别\"开启\"识来\n电\"开关", sender: sender)
//                    case .enabled:
//                        print(1)
////                        RealmUtil.update({ (realm) in
////                            self.userSetting.isAlert = true
////                        })
//                    }
//                })
//            }
//        }
    }
    
 
}

