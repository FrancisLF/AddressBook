//
//  LFContactTableCell.swift
//  AddressBookDemo
//
//  Created by useradmin on 2018/11/22.
//  Copyright © 2018年 francis. All rights reserved.
//

import UIKit

class LFContactTableCell: UITableViewCell {
    
    var nameLabel:UILabelExtensions_lf?
    var teleLabel:UILabelExtensions_lf?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        nameLabel = UILabelExtensions_lf.init()
        nameLabel?.font = UIFont.systemFont(ofSize: 16)
        nameLabel?.textColor = UIColor.black
        nameLabel?._verticalAlignment = .bottom
        
        self.contentView.addSubview(nameLabel!)
        teleLabel = UILabelExtensions_lf.init()
        teleLabel?.font = UIFont.systemFont(ofSize: 14)
        teleLabel?.textColor = UIColor.black
        teleLabel?._verticalAlignment = .top
        self.contentView.addSubview(teleLabel!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel?.frame = CGRect(x: 18, y: 0, width: kScreenWidth-70, height: self.frame.size.height/2)
        teleLabel?.frame = CGRect(x: 18, y: self.frame.size.height/2, width: kScreenWidth-70, height: self.frame.size.height/2)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
