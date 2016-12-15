//
//  HelpViewController.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/12.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bgBlack
        let closeBtn = UIButton.init(type: .system)
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.titleLabel?.font = H1Font
        closeBtn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-10)
            make.height.equalTo(44)
        }
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let title = UILabel()
        title.text = "设置向导"
        title.font = H1BoldFont
        title.textColor = UIColor.white
        view.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(closeBtn.snp.centerY)
        }
        let remark = UILabel()
        remark.text = "请前往\n系统设置-电话-来电阻止与身份识别"
        remark.font = H1Font
        remark.textColor = UIColor.white
        remark.textAlignment = .center
        remark.numberOfLines = 2
        view.addSubview(remark)
        remark.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.left.right.equalTo(view).offset(0)
        }
        let img = UIImageView(image: UIImage(named: "setting"))
        img.contentMode = .scaleAspectFit
        view.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.top.equalTo(remark.snp.bottom).offset(10)
            make.left.right.equalTo(view).inset(20)
            make.bottom.equalTo(view).inset(40)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }


}
