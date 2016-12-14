//
//  SmsCell.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/6.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class SmsCell: MGSwipeTableCell {

    var address: UILabel!
    var time: UILabel!
    var content: UILabel!
    var remake: UILabel!
    // 初始化
    func initialization() {
        address = UILabel()
        address.textColor = UIColor.fontBlack
        address.font = H2Font
        contentView.addSubview(address)
        
        time = UILabel()
        time.textColor = UIColor.fontGray
        time.font = H3Font
        time.textAlignment = .right
        contentView.addSubview(time)
        
        content = UILabel()
        content.textColor = UIColor.fontGray
        content.font = H3Font
        contentView.addSubview(content)
        
        remake = UILabel()
        remake.textColor = UIColor.fontBlack
        remake.font = H3Font
        contentView.addSubview(remake)
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
            make.centerY.equalTo(address)
        }
        
        address.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(time.snp.left).offset(-10)
        }

        remake.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(address.snp.bottom).offset(2)
        }
        
        content.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(remake.snp.bottom).offset(2)
        }
        
        super.layoutSubviews()
    }
}
