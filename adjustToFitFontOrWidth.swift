//
//  adjustToFitFontOrWidth.swift
//  JLStickerTextView
//
//  Created by 刘业臻 on 16/4/25.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import Foundation
import UIKit

protocol adjustFontSizeToFillRectProtocol {
    
    func adjustFontSizeToFillRect(_ newBounds: CGRect, labelView: JLAttributedTextView) -> Void
    func adjustsWidthToFillItsContens(_ view: JLStickerLabelView, labelView: JLAttributedTextView) -> Void
    
}

extension adjustFontSizeToFillRectProtocol {
    func adjustFontSizeToFillRect(_ newBounds: CGRect, labelView: JLAttributedTextView) {
        var mid: CGFloat = 0.0
        var stickerMaximumFontSize: CGFloat = 200.0
        var stickerMinimumFontSize: CGFloat = 15.0
        var difference: CGFloat = 0.0
        
        var tempFont = UIFont(name: labelView.fontName, size: labelView.fontSize)
        var copyTextAttributes = labelView.textAttributes
        copyTextAttributes[NSAttributedStringKey.font] = tempFont
        var attributedText = NSAttributedString(string: labelView.text, attributes: copyTextAttributes)
        
        while stickerMinimumFontSize <= stickerMaximumFontSize {
            mid = stickerMinimumFontSize + (stickerMaximumFontSize - stickerMinimumFontSize) / 2
            tempFont = UIFont(name: labelView.fontName, size: CGFloat(mid))!
            copyTextAttributes[NSAttributedStringKey.font] = tempFont
            attributedText = NSAttributedString(string: labelView.text, attributes: copyTextAttributes)
            
            difference = newBounds.height - attributedText.boundingRect(with: CGSize(width: newBounds.width - 24, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
            
            if (mid == stickerMinimumFontSize || mid == stickerMaximumFontSize) {
                if (difference < 0) {
                    labelView.fontSize = mid - 1
                    return
                }
                
                labelView.fontSize = mid
                return
            }
            
            if (difference < 0) {
                stickerMaximumFontSize = mid - 1
            }else if (difference > 0) {
                stickerMinimumFontSize = mid + 1
            }else {
                labelView.fontSize = mid
                return
            }
        }
        
        labelView.fontSize = mid
        return
    }
    
    func adjustsWidthToFillItsContens(_ view: JLStickerLabelView, labelView: JLAttributedTextView) {
        
        
        let attributedText = labelView.attributedText
        
        let recSize = attributedText?.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let w1 = (ceilf(Float((recSize?.size.width)!)) + 24 < 50) ? view.labelTextView.bounds.size.width : CGFloat(ceilf(Float((recSize?.size.width)!)) + 24)
        let h1 = (ceilf(Float((recSize?.size.height)!)) + 24 < 50) ? 50 : CGFloat(ceilf(Float((recSize?.size.height)!)) + 24)
        
        var viewFrame = view.bounds
        viewFrame.size.width = w1 + 24
        viewFrame.size.height = h1 + 18
        view.bounds = viewFrame
    }
    
}

