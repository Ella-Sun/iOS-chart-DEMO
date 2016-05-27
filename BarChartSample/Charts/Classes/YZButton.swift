//
//  YZButton.swift
//  Charts
//
//  Created by ios on 16/4/12.
//  Copyright © 2016年 dcg. All rights reserved.
//

import Foundation

var  lastLabelTitle = "qq"
public class YZButton : UIButton{
    
    private var label = UILabel?()
    
    @objc func set(image anImage: UIImage?, labelTitle: String,buttonTitle:String ,titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .Center
        self.setImage(anImage, forState: state)
        
        positionLabelRespectToImage(labelTitle, buttonTitle: buttonTitle, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .Center
        self.setTitle(buttonTitle, forState: state)
    }
    
    private func positionLabelRespectToImage(labelTitle: String,buttonTitle:String, position: UIViewContentMode, spacing: CGFloat) {
        
        let imageSize = self.imageRectForContentRect(self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = buttonTitle.sizeWithAttributes([NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .Top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing - 40),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: -titleSize.width)
            
        case .Bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .Left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .Right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
        
        //button中的label
        if(label == nil){
    
            let labelH : CGFloat = 25.0;
            let rect : CGRect = CGRectMake(10,self.frame.size.height / 2 - labelH * 1.5, self.frame.size.width - 20, labelH)
            label = UILabel(frame:rect)
            label!.textColor = UIColor.init(colorLiteralRed: 0.498, green: 0.498, blue: 0.498, alpha: 1.0)
            label!.font = UIFont.systemFontOfSize(16.0);
            label!.textAlignment = NSTextAlignment.Center
            self.addSubview(label!)
        }
        label!.text = lastLabelTitle == labelTitle ? labelTitle : labelTitle
        lastLabelTitle = labelTitle
    }
    
    
}
