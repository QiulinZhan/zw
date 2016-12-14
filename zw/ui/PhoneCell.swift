//
//  PhoneCell.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/5.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class PhoneCell: MGSwipeTableCell {
    
    var phone: UILabel!
    var time: UILabel!
    var remark: UILabel!
    
    // 初始化
    func initialization() {
        phone = UILabel()
        phone.textColor = UIColor.fontBlack
        phone.font = H2Font
        contentView.addSubview(phone)
        
        time = UILabel()
        time.textColor = UIColor.fontGray
        time.font = H3Font
        time.textAlignment = .right
        contentView.addSubview(time)
        
        remark = UILabel()
        remark.textColor = UIColor.fontGray
        remark.font = H3Font
        contentView.addSubview(remark)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }

    override func layoutSubviews() {
        
        time.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(phone).offset(0)
        }
        
        phone.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(time.snp.left).offset(-10)
            make.top.equalTo(contentView).offset(5)
        }
        
        remark.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        super.layoutSubviews()
    }
}
