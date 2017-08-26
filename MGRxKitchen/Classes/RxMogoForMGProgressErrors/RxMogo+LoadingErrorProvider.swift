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


/// 给你一个显示错误信息的error view呗
public protocol NeedHandlErrorOnView
{
    /// 显示Error message toast的 Signal
    ///
    /// - Parameter view: view
    /// - Returns: Toast signal
    func errorViewProvider(on view : UIView) -> PublishSubject<RxMGError>
}

public extension NeedHandlErrorOnView
{
    func errorViewProvider(on view : UIView) -> PublishSubject<RxMGError>
    {
        let errorSb = PublishSubject<RxMGError>()
        errorSb.subscribe(onNext: { (error) in
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
            MGProgressHUD.showTextAndHiddenView(error.apiError.message)
        }).disposed(by: DisposeBag())
        
        return errorSb
    }
}
