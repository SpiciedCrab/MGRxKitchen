//
//  CircleDataView.swift
//  MGProgressHUD
//
//  Created by song on 16/7/14.
//  Copyright © 2016年 song. All rights reserved.
//

import UIKit

class CircleDataView: UIView {
    var fontSize:CGFloat = 14
    var lineSize:CGFloat = 3
    var process:CGFloat = 0
    @IBInspectable var  progress:CGFloat{
        get{
            return process
        }
        set(newval) {
            let val = newval*3.6
            self.process = val
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        
        // println("开始画画.........")
        
        
        //获取画图上下文
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        
        
        //移动坐标
        let x = frame.size.width/2
        let y = frame.size.height/2
        
        
        //第一段文本
        let font:UIFont! = UIFont.systemFont(ofSize: fontSize)
        let textAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName : UIColor.black,
            NSFontAttributeName:font
        ]
        
        
        // println("\(process)...............")
        
        let showp = process/3.6
        
        let str = NSAttributedString(string: "\(Int(showp))%", attributes: textAttributes)
        
        let size:CGSize = str.size()
        
        let stry:CGFloat = y-(size.height/2)
        
        
        str.draw(at: CGPoint(x: x-(size.width/2),y: stry))
        
        //灰色圆圈
        let radius = frame.size.width/2-lineSize
        context.setLineWidth(1)
        
        context.setStrokeColor(UIColor.gray.cgColor)
        context.addArc(center: CGPoint(x: x, y: y), radius: radius-lineSize + 1, startAngle: 0, endAngle: 360, clockwise: false)
        //        CGContextAddArc(context, x, y, radius-lineSize + 1, 0, 360, 0)
        context.drawPath(using: .stroke)
        
        
        //两个圆圈
        context.setLineWidth(lineSize)
        
        context.setStrokeColor(MGColor(125, g: 125, b: 125).cgColor)
        context.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: 0, endAngle: 360, clockwise: false)
        //        CGContextAddArc(context, x, y, radius, 0, 360, 0)
        context.drawPath(using: .stroke)
        
        //
        context.setStrokeColor(MGColor(246, g: 80, b: 0).cgColor)
        process  = process * CGFloat(.pi/180.0)
        //        CGContextAddArc(context, x, y, radius,CGFloat(-M_PI/2), process - CGFloat(M_PI/2), 0)
        context.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: CGFloat(-(CGFloat.pi)/2), endAngle: process - CGFloat(CGFloat.pi/2), clockwise: false)
        context.drawPath(using: .stroke)
        
        
        // println("结束画画........")
        
        
    }
    
}
