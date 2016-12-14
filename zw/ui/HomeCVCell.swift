//
//  HomeCVCell.swift
//  gfw
//
//  Created by Zhanqiulin on 2016/12/1.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit

class HomeCVCell: UICollectionViewCell {
    var title: UILabel! // 公司名
    var img: UIImageView! // 图片
    var maskui: UIView! // 点击效果层
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    // 初始化
    func initialization() {
        layer.cornerRadius = 3
        title = UILabel()
        title.font = H3Font
        title.textColor = UIColor.white
        title.textAlignment = .center
        addSubview(title)
        
        img = UIImageView()
        img.contentMode = .scaleAspectFit
        addSubview(img)
        
        maskui = UIView()
        addSubview(maskui)
    }
    
    override func layoutSubviews() {
        title.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).inset(5)
            make.left.equalTo(self).inset(0)
            make.right.equalTo(self).inset(0)
        }
        
        img.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.bottom.equalTo(title.snp.top).offset(-5)
            make.centerX.equalTo(self).offset(0)
        }
        
        maskui.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(0)
        }
        super.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        maskui.backgroundColor = UIColor.bgMask
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.15, animations: {
            self.maskui.backgroundColor = UIColor.clear
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.15, animations: {
            self.maskui.backgroundColor = UIColor.clear
        })
    }
    
}
