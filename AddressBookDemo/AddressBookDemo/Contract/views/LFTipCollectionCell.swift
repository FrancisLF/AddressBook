//
//  LFTipCollectionCell.swift
//  AddressBookDemo
//
//  Created by useradmin on 2018/11/22.
//  Copyright © 2018年 francis. All rights reserved.
//

import UIKit

class LFTipCollectionCell: UICollectionViewCell {
    var titleLabel:UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.clear
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initSubviews() {
        titleLabel = UILabel.init()
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.textColor = UIColor.green
        self.contentView.addSubview(titleLabel!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = self.contentView.frame
    }
}
