//
//  SmsViewController.swift
//  gfw
//
//  Created by Zhanqiulin on 2016/11/25.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit
import RealmSwift
import MGSwipeTableCell
import SVProgressHUD

class SmsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {

    private let identifier = "smsCell"
    var smsSwitch: SwitchBar! // 短信拦截开关
    var tableView: UITableView! // 表格
    let deleteImg = UIImage(named: "ic_action_discard")!
    var dataList: Results<FraudSms>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "短信拦截"
        view.backgroundColor = UIColor.bgLightGray
        
        smsSwitch = SwitchBar(title: "短信拦截", frame: CGRect.zero)
        view.addSubview(smsSwitch)
        smsSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.right.equalTo(view).offset(0)
            make.height.equalTo(50)
        }
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lineGray
        tableView.separatorInset = UIEdgeInsets.zero
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(smsSwitch.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(view).offset(0)
        }

        loadData { (data) in
            self.tableView.reloadData()
        }
    }
    
    func loadData(_ reload: @escaping (_ data: Results<FraudSms>) -> Void) {
        SVProgressHUD.show()
        ZWRealm.shared.query { (realm) in
            self.dataList = realm.objects(FraudSms.self).sorted(byProperty: "createTime", ascending: false)
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
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SmsCell
        if cell == nil {
            cell = SmsCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.delegate = self
        let sms = dataList[indexPath.row]
        cell?.address.text = sms.address
        cell?.time.text = sms.createTimeStr
        cell?.content.text = sms.content
        cell?.remake.text = sms.remark
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
            let sms = dataList[index]
            let trash = MGSwipeButton.init(title: "", icon: deleteImg, backgroundColor: UIColor.lightRed, padding: 5, callback: { (cell) -> Bool in
                ZWRealm.shared.delete(FraudSms.self, forPrimaryKey: sms.address, { (realm) in
                    self.tableView.reloadData()
                })
                return true
            })
            return [trash]
        }
        return nil
    }
}
