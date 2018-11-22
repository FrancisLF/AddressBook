//
//  UILabelExtensions_lf.swift
//  sijidou
//
//  Created by useradmin on 2018/7/20.
//  Copyright © 2018年 org.quasar. All rights reserved.
//

import UIKit

class UILabelExtensions_lf: UILabel {
    
    public enum VerticalAlignment:NSInteger {
        case top = 0
        case center = 1
        case bottom = 2
    }
    var _verticalAlignment:VerticalAlignment = VerticalAlignment.center{
        didSet{
            self.setNeedsLayout()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        _verticalAlignment = VerticalAlignment.VerticalAlignmentCenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var targetRect:CGRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch self._verticalAlignment {
        case .top :
            targetRect.origin.y = bounds.origin.y
            break
        case .bottom:
            targetRect.origin.y = bounds.origin.y + bounds.size.height - targetRect.size.height
            break
        case .center:
            targetRect.origin.y = bounds.origin.y + (bounds.size.height - targetRect.size.height) / 2.0
            break
            //        default:
            //            break
        }
        return targetRect
    }
    
    override func drawText(in rect: CGRect) {
        let targetRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: targetRect)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
