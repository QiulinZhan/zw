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
