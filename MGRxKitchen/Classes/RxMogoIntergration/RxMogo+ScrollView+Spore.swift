//
//  RxMogo+ScrollView+Spore.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/11/9.
//

import Foundation
import RxCocoa
import RxSwift
import NSObject_Rx

// MARK: - Common Definitions
public class MGRxKichenConfiguration {
    public static var emptyImage: UIImage?
}

public typealias ErrorActionType = ((RxMGError) -> Void)

/// 你想要的错误状态
///
/// - toast: 只是个toast
/// - onView: 弹到view上
/// - custom: 当然你还可以自定义自己玩
public enum MixErrorStatus {
    case toast
    case onView
    case custom(action : ErrorActionType)
}

// MARK: - 基础款搅拌器
/// 超级搅拌器基础款
public class MGRxListWithApiMixer {

    /// 下一个节点
    var nextLink: MGRxListWithApiMixer?

    required public init() { }

    /// 把View和ViewModel之间的绑定做一下啦
    ///
    /// - Parameters:
    ///   - view: 一只普通的view
    ///   - viewModel: viewModel
    public func mixView(view: UIView,
                            togetherWith viewModel: HaveRequestRx) {

        guard let next = nextLink else { return }

        next.mixView(view: view, togetherWith: viewModel)
    }

    /// 创建一个搅拌器组合
    ///
    /// - Parameters:
    ///   - errorShownType: 错误弹出方式
    ///   - mixerReformer: 自定义搅拌器组合啦
    /// - Returns: 你要的超级搅拌器组合款
    public class func createMixChain(errorType errorShownType: MixErrorStatus = .onView,
                                     mixerReformer: (([MGRxListWithApiMixer.Type]) -> [MGRxListWithApiMixer.Type])? = nil)
        -> MGRxListWithApiMixer {

            var chainTypes: [MGRxListWithApiMixer.Type]!

            if let reformer = mixerReformer {
                chainTypes = reformer(defaultMixerInChain(errorType: errorShownType))
            } else {
                chainTypes = defaultMixerInChain(errorType: errorShownType)
            }

            var mixer = MGRxListWithApiMixer()

            for mixerType in chainTypes {
                let existingLink = mixer

                switch errorShownType {
                    case .custom(let action):
                        mixer = CustErrorRequestMixer(action: action)

                    default:
                        mixer = mixerType.init()
                }

                mixer.nextLink = existingLink
            }

            return mixer
    }

    /// 定制好的搅拌器组合
    ///
    /// - Parameter errorShownType: error形态
    /// - Returns: 搅拌器组合集合
    /// 常规款 : Error过滤 -> TableView过滤 -> 普通View过滤
    class func defaultMixerInChain(errorType errorShownType: MixErrorStatus = .onView) -> [MGRxListWithApiMixer.Type] {

        switch errorShownType {
        case .toast:
            return [DefaultRequestMixer.self,
                    PageRequestMixer.self,
                    ToastErrorRequestMixer.self]
        case .onView:
            return [DefaultRequestMixer.self,
                    PageRequestMixer.self,
                    ShowErrorRequestMixer.self]

        case .custom:
            return [DefaultRequestMixer.self,
                    PageRequestMixer.self,
                    CustErrorRequestMixer.self]
        }
    }
}

// MARK: - 附加的搅拌器款
/// 常规View搅拌器
/// 处理了View的loading
public class DefaultRequestMixer: MGRxListWithApiMixer {
    override public func mixView(view: UIView,
                                 togetherWith viewModel: HaveRequestRx) {
        viewModel.loadingActivity
            .asObservable()
            .bind(to: view.rx.isLoading)
            .disposed(by: view.rx.disposeBag)
    }
}

/// ErrorView搅拌器
/// 弹一个error窗在view上
public class ShowErrorRequestMixer: MGRxListWithApiMixer {
    override public func mixView(view: UIView,
                                 togetherWith viewModel: HaveRequestRx) {
        guard let filterErrorViewModel = viewModel as? NeedHandleRequestError else {
            super.mixView(view: view, togetherWith: viewModel)
            return
        }

        filterErrorViewModel.errorProvider
            .distinctRubbish()
            .map { ( $0, MGRxKichenConfiguration.emptyImage) }
            .bind(to: view.rx.emptyErrorViewOnMe)
            .disposed(by: view.rx.disposeBag)

        super.mixView(view: view, togetherWith: viewModel)
    }
}

/// Error Toast搅拌器
/// 弹一个toast窗在view上
public class ToastErrorRequestMixer: MGRxListWithApiMixer {
    override public func mixView(view: UIView,
                                 togetherWith viewModel: HaveRequestRx) {
        guard let filterErrorViewModel = viewModel as? NeedHandleRequestError else {
            super.mixView(view: view, togetherWith: viewModel)
            return
        }

        filterErrorViewModel.errorProvider
            .distinctRubbish()
            .bind(to: view.rx.toastErrorOnMe)
            .disposed(by: view.rx.disposeBag)

        super.mixView(view: view, togetherWith: viewModel)
    }
}

/// 自定义Error搅拌器
/// 送你个Error
public class CustErrorRequestMixer: MGRxListWithApiMixer {

    var errorAction: ErrorActionType!

    convenience public init(action : @escaping ErrorActionType) {
        self.init()
        errorAction = action
    }

    required override public init() {
        super.init()
    }

    override public func mixView(view: UIView,
                                 togetherWith viewModel: HaveRequestRx) {
        guard let filterErrorViewModel = viewModel as? NeedHandleRequestError else {
            super.mixView(view: view, togetherWith: viewModel)
            return
        }

        filterErrorViewModel.errorProvider
            .distinctRubbish()
            .subscribe(onNext: {[weak self] (error) in
                guard let strongSelf = self else { return }
                strongSelf.errorAction(error)
            })
            .disposed(by: view.rx.disposeBag)

        super.mixView(view: view, togetherWith: viewModel)
    }
}

/// Page 搅拌器
/// 处理了一系列上下啦绑定
public class PageRequestMixer: MGRxListWithApiMixer {
    override public func mixView(view: UIView,
                                  togetherWith viewModel: HaveRequestRx) {
        guard let pageViewModel = viewModel as? PagableRequest ,
            let listView = view as? UIScrollView else {
            super.mixView(view: view, togetherWith: viewModel)
            return
        }

        listView.rx
            .pullDownRefreshing
            .bind(to: pageViewModel.firstPage)
            .disposed(by:listView.rx.disposeBag)

        listView.rx
            .pullUpRefreshing
            .bind(to: pageViewModel.nextPage)
            .disposed(by: listView.rx.disposeBag)

        pageViewModel.finalPageReached
            .bind(to: listView.rx.makTouchLastPage)
            .disposed(by: view.rx.disposeBag)

        viewModel.loadingActivity
            .asObservable()
            .bind(to: listView.rx.makMeStopRefreshing)
            .disposed(by: view.rx.disposeBag)
    }
}
