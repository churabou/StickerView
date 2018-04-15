//
//  JLStickerLabelView.swift
//  stickerTextView
//
//  Created by 刘业臻 on 16/4/19.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

public class JLStickerLabelView: UIView {
    //MARK: -
    //MARK: Gestures
    
    private lazy var moveGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JLStickerLabelView.moveGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    internal lazy var singleTapShowHide: UITapGestureRecognizer! = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(JLStickerLabelView.contentTapped(_:)))
        tapRecognizer.delegate = self
        return tapRecognizer
    }()
    
    private lazy var closeTap: UITapGestureRecognizer! = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: (#selector(JLStickerLabelView.closeTap(_:))))
        tapRecognizer.delegate = self
        return tapRecognizer
    }()
    
    private lazy var panRotateGesture: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JLStickerLabelView.rotateViewPanGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    //MARK: -
    //MARK: properties
    
    internal var lastTouchedView: JLStickerLabelView?
    internal var globalInset: CGFloat?
    
    internal var initialBounds: CGRect = .zero
    internal var initialDistance: CGFloat = 0
    
    internal var beginningPoint: CGPoint?
    internal var beginningCenter: CGPoint?
    
    internal var touchLocation: CGPoint = .zero
    
    internal var deltaAngle: CGFloat?
    internal var beginBounds: CGRect?
    
    public var labelTextView: JLAttributedTextView!
    public lazy var rotateView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: self.bounds.size.width - globalInset! * 2,
                                          y: self.bounds.size.height - globalInset! * 2,
                                          width: globalInset! * 2 - 6,
                                          height: globalInset! * 2 - 6))
        v.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        v.backgroundColor = UIColor.clear
        v.clipsToBounds = true
        v.image = UIImage(named: "label_bottom_right.png")
        v.backgroundColor = .red
        v.contentMode = .scaleAspectFit
        v.isUserInteractionEnabled = true
        return v
    }()
    public lazy var closeView: UIImageView = {
        
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: globalInset! * 2 - 6, height: globalInset! * 2 - 6))
        v.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.backgroundColor = UIColor.clear
        v.image = UIImage(named: "label_top_left.png")
        v.isUserInteractionEnabled = true
        return v
    }()
    
    internal var isShowingEditingHandles = true
    
    //MARK: -
    //MARK: Set Control Buttons
    
    public var enableClose: Bool = true {
        didSet {
            closeView.isHidden = enableClose
            closeView.isUserInteractionEnabled = enableClose
        }
    }
    public var enableRotate: Bool = true {
        didSet {
            rotateView.isHidden = enableRotate
            rotateView.isUserInteractionEnabled = enableRotate
        }
    }

    public var showsContentShadow: Bool = false {
        didSet {
            if showsContentShadow {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: 5)
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 4.0
            }else {
                self.layer.shadowColor = UIColor.clear.cgColor
                self.layer.shadowOffset = CGSize.zero
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 0.0
            }
        }
    }
    
    //MARK: -
    //MARK: init
    
    init() {
        super.init(frame: CGRect.zero)
        setup(defaultText: nil)
        adjustsWidthToFillItsContens(self, labelView: labelTextView)
        
    }
    
    init(frame: CGRect, defaultText: String?) {
        super.init(frame: frame)
        
        if frame.size.width < 25 {
            self.bounds.size.width = 25
        }
        
        if frame.size.height < 25 {
            self.bounds.size.height = 25
        }
        
        self.setup(defaultText: defaultText)
        adjustsWidthToFillItsContens(self, labelView: labelTextView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(defaultText: nil)
        adjustsWidthToFillItsContens(self, labelView: labelTextView)
        
    }
    
    
    func setup(defaultText: String?) {
        
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2

        self.globalInset = 19
        
        self.backgroundColor = UIColor.green
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        if let defaultText = defaultText {
            self.setupLabelTextView(defaultText: defaultText)
        } else {
            self.setupLabelTextView()
        }

        
        self.insertSubview(labelTextView!, at: 0)
        
        //setupCloseAndRotateView()
        
        self.addSubview(closeView)
        self.addSubview(rotateView)
        
        
        self.addGestureRecognizer(moveGestureRecognizer)
        self.addGestureRecognizer(singleTapShowHide)
        self.moveGestureRecognizer.require(toFail: closeTap)
        
        self.closeView.addGestureRecognizer(closeTap)
        self.rotateView.addGestureRecognizer(panRotateGesture)
        
        self.enableClose = true
        self.enableRotate = true
        self.showsContentShadow = true
        
        self.showEditingHandles()
        self.labelTextView?.becomeFirstResponder()
        
    }
    
    //MARK: -
    //MARK: didMoveToSuperView
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            self.showEditingHandles()
            self.refresh()
        }
        
    }
}

//MARK: -
//MARK: labelTextViewDelegate

extension JLStickerLabelView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (isShowingEditingHandles) {
            return true
        }
        return false
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        //labelViewDidStartEditing
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (!isShowingEditingHandles) {
            self.showEditingHandles()
        }
        //if textView.text != "" {
        //adjustsWidthToFillItsContens(self, labelView: labelTextView)
        //}
        
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            adjustsWidthToFillItsContens(self, labelView: labelTextView)
            labelTextView.attributedText = NSAttributedString(string: labelTextView.text, attributes: labelTextView.textAttributes)
            
        }
    }
}
//MARK: -
//MARK: GestureRecognizer

extension JLStickerLabelView: UIGestureRecognizerDelegate, adjustFontSizeToFillRectProtocol {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == singleTapShowHide {
            return true
        }
        return false
    }
    
    
    @objc func contentTapped(_ recognizer: UITapGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            //labelViewDidSelected
        }
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        self.removeFromSuperview()
        //labelViewDidClose
    }
    
    @objc func moveGesture(_ recognizer: UIPanGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            //labelViewDidSelected
        }
        
        self.touchLocation = recognizer.location(in: self.superview)
        
        switch recognizer.state {
        case .began:
            beginningPoint = touchLocation
            beginningCenter = self.center
            
            self.center = self.estimatedCenter()
            beginBounds = self.bounds
            
            //labelViewDidBeginEditing
            
        case .changed:
            self.center = self.estimatedCenter()
            
            //labelViewDidChangeEditing
            
        case .ended:
            self.center = self.estimatedCenter()
            
            //labelViewDidEndEditing
            
        default:break
            
        }
    }
    
    
    //簿記
    @objc func rotateViewPanGesture(_ recognizer: UIPanGestureRecognizer) {
        touchLocation = recognizer.location(in: self.superview)
        
        let center = frame.center
        
        switch recognizer.state {
        case .began:
            deltaAngle = atan2(touchLocation.y - center.y, touchLocation.x - center.x) - transform.rotateAngle
            initialBounds = self.bounds
            initialDistance = CalculateFunctions.CGpointGetDistance(center, point2: touchLocation)
            
            //labelViewDidBeginEditing
            
        case .changed:
            let ang = atan2(touchLocation.y - center.y, touchLocation.x - center.x)
            
            let angleDiff = deltaAngle! - ang
            self.transform = CGAffineTransform(rotationAngle: -angleDiff)
            self.layoutIfNeeded()
            
            //Finding scale between current touchPoint and previous touchPoint
            let scale = sqrtf(Float(CGPoint.distance(center, point2: touchLocation) / initialDistance))
            
            
            var scaleRect = initialBounds
            scaleRect.size = initialBounds.size.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
            
            if scaleRect.size.width >= (1 + globalInset! * 2) && scaleRect.size.height >= (1 + globalInset! * 2) && self.labelTextView.text != "" {
                //  if fontSize < 100 || CGRectGetWidth(scaleRect) < CGRectGetWidth(self.bounds) {
                if scale < 1 && labelTextView.fontSize <= 9 {
                    
                }else {
                    self.adjustFontSizeToFillRect(scaleRect, labelView: labelTextView)
                    self.bounds = scaleRect
                    self.adjustsWidthToFillItsContens(self, labelView: labelTextView)
                    //                    self.refresh()
                }
            }
            //labelViewDidChangeEditing
            
        case .ended:
            //labelViewDidEndEditing
            
            self.refresh()
            
        //self.adjustsWidthToFillItsContens(self, labelView: labelTextView)
        default:break
            
        }
    }
}

//MARK: -
//MARK: setup
extension JLStickerLabelView {
    func setupLabelTextView(defaultText: String = "Tap to edit") {

        labelTextView = JLAttributedTextView(frame: self.bounds.insetBy(dx: globalInset!, dy: globalInset!))
        labelTextView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        labelTextView?.clipsToBounds = true
        labelTextView?.delegate = self
        labelTextView?.backgroundColor = UIColor.clear
        labelTextView?.tintColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1)
        labelTextView?.isScrollEnabled = false
        labelTextView.isSelectable = true
        labelTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        labelTextView?.text = defaultText
        labelTextView?.layer.borderWidth = 2
        labelTextView?.layer.borderColor = UIColor.orange.cgColor
    }
}


//MARK: -
//MARK: Help funcitons
extension JLStickerLabelView {
    
    internal func refresh() {
        if let superView: UIView = self.superview {
            let transform: CGAffineTransform = superView.transform
            let scale = CalculateFunctions.CGAffineTransformGetScale(transform)
            let t = CGAffineTransform(scaleX: scale.width, y: scale.height)
            self.closeView.transform = t.inverted()
            self.rotateView.transform = t.inverted()
        }
    }
    
    public func hideEditingHandlers() {
        lastTouchedView = nil
        
        isShowingEditingHandles = false
        
        if enableClose {
            closeView.isHidden = true
        }
        if enableRotate {
            rotateView.isHidden = true
        }
        
        labelTextView.resignFirstResponder()
        
        self.refresh()
        //labelViewDidHideEditingHandles
    }
    
    public func showEditingHandles() {
        lastTouchedView?.hideEditingHandlers()
        
        isShowingEditingHandles = true
        
        lastTouchedView = self
        
        if enableClose {
            closeView.isHidden = false
        }
        
        if enableRotate {
            rotateView.isHidden = false
        }
        
        self.refresh()
        
        //labelViewDidShowEditingHandles
    }
    
    internal func estimatedCenter() -> CGPoint{
        let newCenter: CGPoint!
        var newCenterX = beginningCenter!.x + (touchLocation.x - beginningPoint!.x)
        var newCenterY = beginningCenter!.y + (touchLocation.y - beginningPoint!.y)
        
        newCenter = CGPoint(x: newCenterX, y: newCenterY)
        
        return newCenter
    }
}
