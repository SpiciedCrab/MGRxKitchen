//
//  MGProgressHUDTool.swift
//  Demo
//
//  Created by 刘明杰 on 2017/7/24.
//  Copyright © 2017年 Winann. All rights reserved.
//

import UIKit

var KScreenWidth = UIScreen.main.bounds.width
var KScreenHeight = UIScreen.main.bounds.height

func MGColor(_ r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
}

func MGAttributedString(_ label:UILabel,text:String?,lineSpacing:CGFloat) -> NSAttributedString?{
    if nil != text {
        let string = NSMutableAttributedString(string: text!)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        style.alignment = label.textAlignment
        style.lineSpacing = lineSpacing
        style.headIndent = 0.0
        style.paragraphSpacing = 0.0
        style.paragraphSpacingBefore = 0.0
        style.firstLineHeadIndent = 0.0
        string.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: text!.characters.count))
        string.addAttribute(NSFontAttributeName, value: label.font, range: NSRange(location: 0, length: text!.characters.count))
        string.addAttribute(NSForegroundColorAttributeName, value: label.textColor, range: NSRange(location: 0, length: text!.characters.count))
        return string
    }
    return nil
}

public enum  MGLocationMode{
    case top
    case center
    case bottom
}

public enum  MGCustomMode{
    case `default`
    case progress
}

public func lastShowWindow() -> UIWindow{
    var window = UIApplication.shared.windows.last
    let count = UIApplication.shared.windows.count
    if window?.bounds.width != KScreenWidth {
        if count > 2 {
            window = UIApplication.shared.windows[count - 2]
        }
        else
        {
            window = UIApplication.shared.keyWindow
        }
    }
    if window?.isHidden == true {
        window = UIApplication.shared.keyWindow
    }
    return window!
}

