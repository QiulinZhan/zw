//
//  PhoneViewController.swift
//  gfw
//
//  Created by Zhanqiulin on 2016/12/1.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit
import RealmSwift
import MGSwipeTableCell
import SVProgressHUD
import CallKit

class PhoneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    
    private let identifier = "phoneCell"
    var alertSwitch: SwitchBar! // 来电提示开关
    var phoneSwitch: SwitchBar! // 拦截开关
    var tableView: UITableView! // 表格
    let deleteImg = UIImage(named: "ic_action_discard")!
    var dataList: Results<FraudPhone>!
    var userSetting: UserSetting!
    var settingView: UIView!
    var vc: HelpViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "电话拦截"
        view.backgroundColor = UIColor.bgLightGray
        alertSwitch = SwitchBar(title: "来电提示", frame: CGRect.zero)
        view.addSubview(alertSwitch)
        alertSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.right.equalTo(view).offset(0)
            make.height.equalTo(50)
        }
        alertSwitch.iswitch.addTarget(self, action: #selector(switchChange(sender:)), for: .valueChanged)

        phoneSwitch = SwitchBar(title: "电话拦截", frame: CGRect.zero)
        view.addSubview(phoneSwitch)
        phoneSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(alertSwitch.snp.bottom).offset(1)
            make.left.right.equalTo(view).offset(0)
            make.height.equalTo(50)
        }
        phoneSwitch.switchChange = { sender in
            RealmUtil.update({ (realm) in
                self.userSetting.isStopCall = sender.isOn
            })
        }
        phoneSwitch.iswitch.addTarget(self, action: #selector(switchChange(sender:)), for: .valueChanged)
            
        RealmUtil.query { (realm) in
            self.userSetting = realm.object(ofType: UserSetting.self, forPrimaryKey: "call110")
            self.alertSwitch.iswitch.isOn = false
            self.phoneSwitch.iswitch.isOn = self.userSetting.isStopCall
        }
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lineGray
        tableView.separatorInset = UIEdgeInsets.zero

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneSwitch.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(view).offset(0)
        }
        
        loadData { (data) in
            self.tableView.reloadData()
        }
        
        settingView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 101))
        settingView.backgroundColor = UIColor.white
        view.addSubview(settingView)
        let settingBtn = UIButton.init(type: .system)
        settingBtn.setTitle("无法识别骚扰，请开启开关", for: .normal)
        settingBtn.titleLabel?.font = H1Font
        settingBtn.setTitleColor(UIColor.white, for: .normal)
        settingBtn.backgroundColor = UIColor.btnBlue
        settingView.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(settingView).inset(0)
        }
        settingBtn.addTarget(self, action: #selector(gotoSetting), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandle), name: Notification.Name.init(rawValue: "Call110Notification"), object: nil)
        checkPermissions { (status) in
            
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
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "Call110Notification"), object: nil)
    }
    
    func checkPassed() {
        if vc != nil {
            vc.dismiss(animated: true, completion: nil)
        }
        settingView.isHidden = true
    }
    
    // 去设置
    func gotoSetting() {
        settingView.isHidden = false
        RealmUtil.query { (realm) in
            let setting = realm.object(ofType: UserSetting.self, forPrimaryKey: "call110")
            try! realm.write {
                setting?.isAlert = false
                setting?.isStopSms = false
                setting?.isStopCall = false
            }
        }
        vc = HelpViewController()
        present(vc, animated: true, completion: nil)
    }
    
    /// 提示框
    func showAlert(title: String, message: String, sender: UISwitch) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: {
            sender.isOn = false
        })
    }
    
    func loadData(_ reload: @escaping (_ data: Results<FraudPhone>) -> Void) {
        SVProgressHUD.show()
        RealmUtil.query { (realm) in
            self.dataList = realm.objects(FraudPhone.self).sorted(byProperty: "createTime", ascending: false)
            reload(self.dataList)
            SVProgressHUD.dismiss()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList != nil {
            return dataList.count
        }
//        tableView.tableViewTips(withMsg: nil, ifNecessaryForRowCount: UInt(count))
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PhoneCell
        if cell == nil {
            cell = PhoneCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        cell?.delegate = self
        let phone = dataList[indexPath.row]
        cell?.phone.text = phone.phone
        cell?.time.text = phone.createTimeStr
        cell?.remark.text = phone.remark
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return true
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        if direction == MGSwipeDirection.rightToLeft {
            swipeSettings.transition = .border
            expansionSettings.fillOnTrigger = false
            let index = tableView.indexPath(for: cell)!.row
            let phone = dataList[index]
            let trash = MGSwipeButton.init(title: "", icon: deleteImg, backgroundColor: UIColor.lightRed, padding: 5, callback: { (cell) -> Bool in
                RealmUtil.delete(FraudPhone.self, forPrimaryKey: phone.phone, { (realm) in
                    self.tableView.reloadData()
                })
                return true
            })
            return [trash]
        }
        return nil
    }
    
    // 检查权限
    func checkPermissions(_ completionHandler: @escaping (_ status: CXCallDirectoryManager.EnabledStatus) -> Void) {
        if #available(iOS 10.0, *) {
            SVProgressHUD.show()
            let manager = CXCallDirectoryManager.sharedInstance
            manager.getEnabledStatusForExtension(withIdentifier: "cn.call110.zw.CallEx", completionHandler: {(status, error) in
                //            guard error == nil else {
                //                print(error.debugDescription)
                //                return
                //            }
                if error == nil {
//                    completionHandler(status)
                    NotificationCenter.default.post(name: Notification.Name.init(rawValue: "Call110Notification"), object: nil, userInfo:
                        ["type": "yellowpage", "status": status])
                } else {
                    print(error.debugDescription)
                }
                
                SVProgressHUD.dismiss()
            })
        }
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
        if sender == phoneSwitch.iswitch {
            if userSetting.isStopCall {
                RealmUtil.update({ (realm) in
                    self.userSetting.isStopCall = false
                })
            } else {
                checkPermissions({ (status) in
                    switch status {
                    case .unknown:
                        self.showAlert(title: "系统错误", message: "请重装应用", sender: sender)
                    case .disabled:
                        self.showAlert(title: "请开启设置开关", message: "请前往\"系统设置-电话-来电\n阻止与身份识别\"开启\"拦骚\n扰\"开关", sender: sender)
                    case .enabled:
                        RealmUtil.update({ (realm) in
                            self.userSetting.isStopCall = true
                        })
                    }
                })
            }
        } else {
            if userSetting.isAlert {
                let realm = try! Realm()
                try! realm.write {
                    self.userSetting.isAlert = false
                }
            } else {
                checkPermissions({ (status) in
                    switch status {
                    case .unknown:
                        self.showAlert(title: "系统错误", message: "请重装应用", sender: sender)
                    case .disabled:
                        self.showAlert(title: "请开启设置开关", message: "请前往\"系统设置-电话-来电\n阻止与身份识别\"开启\"识来\n电\"开关", sender: sender)
                    case .enabled:
                        print(1)
//                        RealmUtil.update({ (realm) in
//                            self.userSetting.isAlert = true
//                        })
                    }
                })
            }
        }
    }
    
 
}

