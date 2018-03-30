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
import MGCore

// MARK: - MGProgress Toast Extensions
public enum MessagePosition {
    case top(message : String?)
    case center(message : String?)
    case bottom(message : String?)
}

// MARK: - MGProgress Toast Rxs
public extension Reactive where Base : UIView {

    /// 展示个普通toast
    var toastOnBottomToMe: UIBindingObserver<Base, String> {

        return UIBindingObserver(UIElement: self.base, binding: { view, message in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view,
                                                message: message,
                                                loationMode: .bottom)

        })
    }

    var toastOnTopToMe: UIBindingObserver<Base, String> {

        return UIBindingObserver(UIElement: self.base, binding: { view, message in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view,
                                                message: message,
                                                loationMode: .top)
        })
    }

    var toastOnCenterToMe: UIBindingObserver<Base, String> {

        return UIBindingObserver(UIElement: self.base, binding: { view, message in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view,
                                                message: message,
                                                loationMode: .center)
        })
    }

    /// 展示个错误toast
    var toastErrorOnMe: UIBindingObserver<Base, RxMGError> {

        return UIBindingObserver(UIElement: self.base, binding: { view, error in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view, message: error.apiError.message)
        })
    }

    /// 展示个成功toast
    var successCheckOnMe: UIBindingObserver<Base, String> {

        return UIBindingObserver(UIElement: self.base, binding: { view, message in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showSuccessAndHiddenView(view, message: message)

        })
    }

    /// 展示个空态页面
    var emptyViewOnMe: UIBindingObserver<Base, (message: String, icon: UIImage?)> {

        return UIBindingObserver(UIElement: self.base, binding: { view, info in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)

            MGProgressHUD.showFillView(view,
                                       iconImage: info.icon,
                                       message: info.message,
                                       detailText: nil)
        })
    }

    /// 展示个空态页面
    var emptyErrorViewOnMe: UIBindingObserver<Base, (error: RxMGError, icon: UIImage?)> {

        return UIBindingObserver(UIElement: self.base, binding: { view, info in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showFillView(view,
                                       iconImage: info.icon,
                                       message: info.error.apiError.message,
                                       detailText: nil)
        })
    }

    /// 是否需要loading呐
    var isLoading: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { view, isVisible in
            if isVisible {
                MGProgressHUD.showLoadingView(view, message: nil)
            } else {
                MGProgressHUD.hiddenAllhubToView(view, animated: true)
            }
        }
    }
}
//
///// 自己需要实现它啊啊啊啊
//public protocol MGCustomizing {
//    static func showLoadingView(_ toView: UIView!, message: String?) -> MGProgressHUD?
//}
//
//// MARK: - MGProgressView Extensions
//extension MGProgressHUD {
//
//    /// Show 一个loading
//    ///
//    /// - Parameters:
//    ///   - toView: view
//    ///   - message: muyou yong
//    /// - Returns: MGProgress
//    @discardableResult
//    public class func showLoadingView(_ toView: UIView!, message: String?) -> MGProgressHUD? {
//
//        assert(false, "去你自己的Lib里重写这个方法吧，你看到我就说明你是猪")
//        return MGProgressHUD()
//    }
//
//}
