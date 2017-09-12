//
//  MGProgressHUD_extension.swift
//  Pods
//
//  Created by song on 2017/9/10.
//
//

import UIKit

public extension MGProgressHUD {
    @available(*, deprecated:2.1.11, message:"不推荐使用，请使用iconImage:UIImage")
    @discardableResult
    public class func showView(_ toView:UIView?,
                               icons:[String]?,
                               message:String?,
                               messageColor:UIColor?,
                               showBgView:Bool?,
                               detailText:String?,
                               detailColor:UIColor?,
                               loationMode:MGLocationMode?) -> MGProgressHUD?{
     
        var iconImages: [UIImage]?
        if let `icons` = icons {
            iconImages = icons.flatMap({ (imageName) -> UIImage? in
                return UIImage(named: imageName)
            })
        }
        
        return showView(toView,
                        iconImages: iconImages,
                        message: message,
                        messageColor: messageColor,
                        showBgView: showBgView,
                        detailText: detailText,
                        detailColor: detailColor,
                        loationMode: loationMode)
    }
    
    @available(*, deprecated:2.1.11, message:"不推荐使用，请使用iconImage:UIImage")
    @discardableResult
    public class func  showView(_ toView:UIView!,
                                icon:String?,
                                message:String?,
                                messageColor:UIColor?,
                                detailText:String?,
                                detailColor:UIColor?) ->MGProgressHUD? {
        var image:UIImage?
        if let `icon` = icon {
            image = UIImage(named:icon)
        }
        return showView(toView,
                        iconImage: image,
                        message: message,
                        messageColor: messageColor,
                        detailText: detailText,
                        detailColor: detailColor)
    }

    @available(*, deprecated:2.1.11, message:"不推荐使用，请使用iconImage:UIImage")
    /*! 扩展方法 */
    @discardableResult
    public class func  showView(_ toView:UIView!,
                                icon:String?,
                                message:String?,
                                detailText:String?) ->MGProgressHUD? {
        
        return showView(toView,
                        icon: icon,
                        message: message,
                        messageColor: nil,
                        detailText: detailText,
                        detailColor: nil)
    }
    
    @available(*, deprecated:2.1.11, message:"不推荐使用，请使用iconImage:UIImage")
    /*! 扩展方法 */
    @discardableResult
    public class func  showFillView(_ toView:UIView!,
                                    icon:String?,
                                    message:String?,
                                    detailText:String?) ->MGProgressHUD? {
        let progressView = showView(toView,
                                    icon: icon,
                                    message: message,
                                    messageColor: nil,
                                    detailText: detailText,
                                    detailColor: nil)
        progressView?.backgroundColor = toView.backgroundColor
        return progressView
    }
    
    @available(*, deprecated:2.1.11, message:"不推荐使用，请使用iconImage:UIImage")
    @discardableResult
    public class func  showFillViewAndCallBack(_ toView:UIView!,
                                               icon:String?,
                                               message:String?,
                                               detailText:String?,
                                               callBack:@escaping ()->()) ->MGProgressHUD? {
        let progressView = showView(toView,
                                    icon: icon,
                                    message: message,
                                    messageColor: nil,
                                    detailText: detailText,
                                    detailColor: nil)
        progressView?.backgroundColor = toView.backgroundColor
        progressView?.completionBlock = callBack
        return progressView
    }
    
    @available(*, deprecated:2.1.11, message:"不推荐使用，请使用iconImage:UIImage")
    @discardableResult
    public class func showSuccessAndHiddenView(_ toView:UIView!,
                                               icon:String?,
                                               message:String?,
                                               detailText:String?) ->MGProgressHUD? {
        var image:UIImage?
        if let `icon` = icon {
            image = UIImage(named:icon)
        }
        return showSuccessAndHiddenView(toView,
                                        iconImage: image,
                                        message: message,
                                        detailText: detailText)
    }
}
