//
//  RxMogo+LoadingErrorProvider.swift
//  RxMogo
//
//  Created by Harly on 2017/8/26.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MGProgressHUD
import MGBricks

public enum MessagePosition
{
    case top(message : String?)
    case center(message : String?)
    case bottom(message : String?)
}

public extension Reactive where Base : UIView
{
    /// 展示个普通toast
    var toastOnBottomToMe: UIBindingObserver<Base, String> {
        
        return UIBindingObserver(UIElement: self.base, binding: { (view, message) in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view, message: message , loationMode : .bottom)

        })
    }
    
    var toastOnTopToMe: UIBindingObserver<Base, String> {
        
        return UIBindingObserver(UIElement: self.base, binding: { (view, message) in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view, message: message , loationMode : .top)
        })
    }
    
    var toastOnCenterToMe: UIBindingObserver<Base, String> {
        
        return UIBindingObserver(UIElement: self.base, binding: { (view, message) in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view, message: message , loationMode : .center)
        })
    }

    
    /// 展示个错误toast
    var toastErrorOnMe: UIBindingObserver<Base, RxMGError> {
        
        return UIBindingObserver(UIElement: self.base, binding: { (view, error) in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view, message: error.apiError.message)
        })
    }

    /// 展示个成功toast
    var successCheckOnMe: UIBindingObserver<Base, String> {
        
        return UIBindingObserver(UIElement: self.base, binding: { (view, message) in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showSuccessAndHiddenView(view, message: message)
            
        })
    }
    
    /// 展示个空态页面
    var emptyViewOnMe: UIBindingObserver<Base, String> {
        
        return UIBindingObserver(UIElement: self.base, binding: { (view, message) in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showFillView(view, icon: "", message: message, detailText: nil)
        })
    }
    
    /// 展示个空态页面
    var emptyErrorViewOnMe: UIBindingObserver<Base, RxMGError> {
        
        return UIBindingObserver(UIElement: self.base, binding: { (view, error) in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showFillView(view, icon: "", message: error.apiError.message, detailText: nil)
        })
    }
    
    /// 是否需要loading呐
    var isLoadingOnMe: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { view, isVisible in
            if isVisible {
                MGProgressHUD.showLoadingView(view, message: nil)
            } else {
                MGProgressHUD.hiddenAllhubToView(view, animated: true)
            }
        }
    }
}

public extension MGProgressHUD{
    
    @discardableResult
    public class func  showLoadingView(_ toView:UIView!,message:String?)->MGProgressHUD?{
        var arr  = [String]()
        for index in 1..<10 {
            arr.append("loading" + String(index))
        }
        let progressView = MGProgressHUD.showView(toView, icons: arr, message: nil, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: nil)
        progressView?.marginEdgeInsets = UIEdgeInsetsMake(5, UIScreen.main.bounds.width/2 - 50, 5, UIScreen.main.bounds.width/2 - 50)
        return progressView
    }
    
}

