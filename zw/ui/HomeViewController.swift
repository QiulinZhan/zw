//
//  HomeViewController.swift
//  gfw
//
//  Created by Zhanqiulin on 2016/11/25.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private let identifier = "homebtncell"
    var collectionView: UICollectionView!
    private let images = ["icon_tel", "icon_msm", "icon_query", "icon_advice"]
    private let colors = [UIColor.btnYellow, UIColor.btnGreen, UIColor.btnRed, UIColor.btnBlue]
    private let titles = ["电话拦截", "短信拦截", "号码查询", "意见反馈"]
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        let mainView = UIView(frame: self.view.frame)
        mainView.backgroundColor = UIColor.bgBlack
        view.addSubview(mainView)
        let webview = UIWebView()
//        webview.loadRequest(URLRequest(url: URL(string: "http://www.madisoft.cn")!))
        mainView.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalTo(mainView).inset(UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0))
        }
        
        let w = (screenWidth - 20 - 60) / 4
        let layout = UICollectionViewFlowLayout() // 初始化UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 20// 水平最小距离
        layout.itemSize = CGSize.init(width: w, height:w) // item的大小
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.bgLightGray // 背景色
        collectionView.showsVerticalScrollIndicator = false // 去除垂直滚动条
        collectionView.showsHorizontalScrollIndicator = false // 去除水平滚动条
        collectionView.dataSource = self // 代理方法
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(HomeCVCell.self, forCellWithReuseIdentifier: identifier)
        mainView.addSubview(collectionView)// 添加主视图
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(mainView).offset(0)
            make.left.right.equalTo(mainView).offset(0)
            make.height.equalTo(30 + w)
        }
        
        let one = BlackPhone()
        one.phone = "+8618584357332"
        one.city = "jilin"
        one.remark = "大骗子"
        one.type = 1
        let two = BlackPhone()
        two.phone = "+8613154305656"
        two.city = "jilin"
        two.remark = "骗死你"
        two.type = 0
        ZWRealm.shared.write([one, two]) { (r) in
            
        }
       
//        RealmUtil.delete(BlackPhone.self, forPrimaryKey: one.phone) { (r) in
//            
//        }
        ZWRealm.shared.query { (realm) in
            
            realm.objects(BlackPhone.self).sorted(byProperty: "phone").forEach({ (e) in
                print("12121212" + e.phone)
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? HomeCVCell else {
            return HomeCVCell()
        }
        cell.backgroundColor = colors[indexPath.row]
        cell.img.image = UIImage(named: images[indexPath.row])
        cell.title.text = titles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var vc: UIViewController!
        switch indexPath.row {
        case 0:
            vc = PhoneViewController()
        case 1:
            vc = SmsViewController()
        case 2:
            vc = QueryViewController()
        case 3:
            vc = SuggestionViewController()
        default:
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
