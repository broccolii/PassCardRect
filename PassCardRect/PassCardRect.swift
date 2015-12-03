//
//  PassCardView.swift
//  PassCardView
//
//  Created by Broccoli on 15/11/30.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

class PassCardRect: UIView {
    /// 设置键盘类型
    var keyboardType = UIKeyboardType.NumberPad
    
    var passwordChangeBlock: ((String) -> Void)!
    
    private var viewWidth = 240
    private var viewHeight = 40
    
    var inputString: String = ""
    
    private var inputStringLength: Int {
        return self.inputString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
    }
    
    private lazy var centerPointsArr: [CGPoint] = {
        var arr = [CGPoint]()
        for i in 0..<6 {
            let point = CGPoint(x: self.bounds.width * (CGFloat(i) * 2  + 1.0) / 12.0, y: self.bounds.height / 2.0)
            arr.append(point)
        }
        return arr
    }()
    
    private lazy var linesArr: [CALayer] = {
        var arr = [CALayer]()
        for i in 0..<6 {
            let layer = CALayer()
            layer.bounds = CGRect(x: 0, y: 0, width: 20, height: 3)
            layer.backgroundColor = UIColor.blackColor().CGColor
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            layer.position = self.centerPointsArr[i]
            arr.append(layer)
        }
        return arr
    }()
    
    private lazy var circlesArr: [CALayer] = {
        var arr = [CALayer]()
        for i in 0..<6 {
            let layer = CALayer()
            layer.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
            layer.cornerRadius = 4
            layer.allowsEdgeAntialiasing = true
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            layer.backgroundColor = UIColor.blackColor().CGColor
            layer.position = self.centerPointsArr[i]
            layer.opacity = 0.0
            arr.append(layer)
        }
        return arr
    }()
    
    init(center: CGPoint) {
        super.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        backgroundColor = UIColor.clearColor()
        addSubLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubLayers() {
//        for line in linesArr {
//            layer.addSublayer(line)
//        }
        
        for circle in circlesArr {
            layer.addSublayer(circle)
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func drawRect(rect: CGRect) {
        layer.borderWidth = 1 / UIScreen.mainScreen().scale
        layer.cornerRadius = 4.0
        layer.allowsEdgeAntialiasing = false
        layer.borderColor = UIColor.blackColor().CGColor
        
        
        let ctx = UIGraphicsGetCurrentContext()
        for i in 1..<6 {
            CGContextAddLines(ctx, [CGPoint(x: CGFloat(i) * bounds.width / 6, y: 0), CGPoint(x: CGFloat(i) * bounds.width / 6, y: bounds.height)], 2)
        }
        CGContextSetLineWidth(ctx, 1 / UIScreen.mainScreen().scale)
        CGContextSetAllowsAntialiasing(ctx, false)
        CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
    }
}

extension PassCardRect: UIKeyInput {
    func hasText() -> Bool {
        return inputStringLength > 0
    }
    
    func insertText(text: String) {
        if inputStringLength == 6 {
            return
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.linesArr[self.inputStringLength].opacity = 0.0
            self.circlesArr[self.inputStringLength].opacity = 1.0
            self.circlesArr[self.inputStringLength].transform = CATransform3DMakeScale(1.3, 1.3, 1.0)
            }) { (finished) -> Void in
                if self.inputStringLength != 6 {
                    self.inputString = self.inputString + text
                }
                if let _ = self.passwordChangeBlock {
                    self.passwordChangeBlock(self.inputString)
                }
        }
    }
    
    func deleteBackward() {
        if inputStringLength == 1 {
            inputString = ""
        } else if inputString != "" {
            inputString.removeAtIndex(inputString.endIndex.predecessor())
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.linesArr[self.inputStringLength].opacity = 1.0
            self.circlesArr[self.inputStringLength].opacity = 0.0
            self.circlesArr[self.inputStringLength].transform = CATransform3DMakeScale(1.3, 1.3, 1.0)
            }) { (finished) -> Void in
                if let _ = self.passwordChangeBlock {
                    self.passwordChangeBlock(self.inputString)
                }
        }
    }
}
