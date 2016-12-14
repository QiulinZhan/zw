//
//  SwitchBar.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/2.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit

class SwitchBar: UIView {
    var label: UILabel!
    var iswitch: UISwitch!
    var switchChange: ((UISwitch) -> Void)?
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
        initialization(title: title)
    }
    
    // 初始化
    func initialization(title: String) {
        backgroundColor = UIColor.white
        // 开关
        iswitch = UISwitch()
        addSubview(iswitch)
        
        // 标题
        label = UILabel()
        label.font = H1Font
        label.textColor = UIColor.fontBlack
        label.text = title
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization(title: "")
    }
    
    override func layoutSubviews() {
        iswitch.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self).offset(0)
        }
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(iswitch.snp.left).offset(-10)
            make.centerY.equalTo(self).offset(0)
        }
        super.layoutSubviews()
    }
}
