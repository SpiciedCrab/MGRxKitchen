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

/// 获取图片（其实是copy来的）
///
/// - Parameters:
///   - name: name
///   - inClass: class
///   - resourceName: nil
/// - Returns: image
public func imageFetcher(name: String,
                         bundle inClass: Swift.AnyClass,
                         with resourceName: String? = nil) -> UIImage? {
    
    let imageBundle = bundle(for: inClass, withResource: resourceName)
    return UIImage(named: name, in: imageBundle, compatibleWith: nil)
}


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
            MGProgressHUD.showTextAndHiddenView(view, message: message, loationMode : .bottom)

        })
    }

    var toastOnTopToMe: UIBindingObserver<Base, String> {

        return UIBindingObserver(UIElement: self.base, binding: { view, message in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view, message: message, loationMode : .top)
        })
    }

    var toastOnCenterToMe: UIBindingObserver<Base, String> {

        return UIBindingObserver(UIElement: self.base, binding: { view, message in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(view, message: message, loationMode : .center)
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
    var emptyViewOnMe: UIBindingObserver<Base, String> {

        return UIBindingObserver(UIElement: self.base, binding: { view, message in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            
            imageFetcher(name: "", bundle: view.self())
            
            MGProgressHUD.showFillView(view, iconImage: nil, message: message, detailText: nil)
        })
    }

    /// 展示个空态页面
    var emptyErrorViewOnMe: UIBindingObserver<Base, RxMGError> {

        
        return UIBindingObserver(UIElement: self.base, binding: { view, error in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showFillView(view, iconImage: nil, message: error.apiError.message, detailText: nil)
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

// MARK: - MGProgressView Extensions
public extension MGProgressHUD {

    /// Show 一个loading
    ///
    /// - Parameters:
    ///   - toView: view
    ///   - message: muyou yong
    /// - Returns: MGProgress
    @discardableResult
    public class func  showLoadingView(_ toView: UIView!, message: String?) -> MGProgressHUD? {
        var arr  = [UIImage]()
        let bundle = Bundle(for: MGProgressHUD.self)
        for index in 1..<10 {
            if let image = UIImage(named: "loading" + String(index), in: bundle, compatibleWith: nil) {
                arr.append(image)
            }
        }
        let progressView = MGProgressHUD.showView(toView,
                                                  iconImages: arr,
                                                  message: nil,
                                                  messageColor: nil,
                                                  showBgView: false,
                                                  detailText: nil,
                                                  detailColor: nil,
                                                  loationMode: nil)

        progressView?.marginEdgeInsets = UIEdgeInsets(top: 5,
                                                      left: UIScreen.main.bounds.width / 2,
                                                      bottom: 5,
                                                      right: UIScreen.main.bounds.width / 2 - 50)
        return progressView
    }

}
