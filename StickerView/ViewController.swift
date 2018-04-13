//
//  ViewController.swift
//  StickerView
//
//  Created by 刘业臻 on 16/6/15.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, adjustFontSizeToFillRectProtocol {
    
    
    var stickerView = JLStickerImageView()
    
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labelFrame = CGRect(x: view.bounds.midX - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                y: view.bounds.midY - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                width: 60, height: 50)
        let labelView = JLStickerLabelView(frame: labelFrame, defaultText: "defaultText")
        
        labelView.showsContentShadow = false
        //labelView.enableMoveRestriction = false
        labelView.borderColor = UIColor.red
        labelView.labelTextView.fontName = "Baskerville-BoldItalic"
        view.addSubview(labelView)
     
        adjustsWidthToFillItsContens(labelView, labelView: labelView.labelTextView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

