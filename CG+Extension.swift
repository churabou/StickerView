//
//  CG+Extension.swift
//  StickerView
//
//  Created by ちゅーたつ on 2018/04/12.
//  Copyright © 2018年 luiyezheng. All rights reserved.
//

import UIKit

extension CGAffineTransform {
    
    //radian
    var rotateAngle: CGFloat {
        return atan2(b, a)
    }
}

extension CGPoint {
    
    static func distance(_ point1: CGPoint, point2: CGPoint) -> CGFloat {
        let fx = point2.x - point1.x
        let fy = point2.y - point1.y
        
        return sqrt((fx * fx + fy * fy))
    }
}

extension CGSize {
    
    func scaleBy(x: CGFloat, y: CGFloat) -> CGSize {
        return CGSize(width: width * x, height: height * y)
    }
    
    func transformBy(x: CGFloat, y: CGFloat) -> CGSize {
        return CGSize(width: width + x, height: height + y)
    }
}


extension CGRect {
    
    //アフィン変換後のframeから中心取得できる(アフィン変換は中心を基準)
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
