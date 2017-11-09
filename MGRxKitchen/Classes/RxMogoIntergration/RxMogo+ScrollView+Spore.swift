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

public class MGRxKichenConfiguration {
    public static var emptyImage: UIImage?
}

public typealias ErrorActionType = ((RxMGError) -> Void)

public enum MixErrorStatus {
    case toast
    case onView
    case custom(action : ErrorActionType)
}

public class MGRxListWithApiMixer {

    var nextLink: MGRxListWithApiMixer?

    required public init() { }

    public func mixListView(listView: UIScrollView,
                            togetherWith viewModel: HaveRequestRx) {

        guard let next = nextLink else { return }

        next.mixListView(listView: listView, togetherWith: viewModel)
    }

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

    class func defaultMixerInChain(errorType errorShownType: MixErrorStatus = .onView) -> [MGRxListWithApiMixer.Type] {

        switch errorShownType {
        case .toast:
            return [DefaultRequestMixer.self,
                    ToastErrorRequestMixer.self,
                    PageRequestMixer.self]
        case .onView:
            return [DefaultRequestMixer.self,
                    ShowErrorRequestMixer.self,
                    PageRequestMixer.self]

        case .custom:
            return [DefaultRequestMixer.self,
                    CustErrorRequestMixer.self,
                    PageRequestMixer.self]
        }
    }
}

public class DefaultRequestMixer: MGRxListWithApiMixer {
    override public func mixListView(listView: UIScrollView,
                                     togetherWith viewModel: HaveRequestRx) {
        viewModel.loadingActivity
            .asObservable()
            .bind(to: listView.rx.makMeStopRefreshing)
            .disposed(by: listView.rx.disposeBag)
    }
}

public class ShowErrorRequestMixer: MGRxListWithApiMixer {
    override public func mixListView(listView: UIScrollView,
                                     togetherWith viewModel: HaveRequestRx) {
        guard let filterErrorViewModel = viewModel as? NeedHandleRequestError else {
            super.mixListView(listView: listView, togetherWith: viewModel)
            return
        }

        filterErrorViewModel.errorProvider
            .distinctRubbish()
            .map { ( $0, MGRxKichenConfiguration.emptyImage) }
            .bind(to: listView.rx.emptyErrorViewOnMe)
            .disposed(by: listView.rx.disposeBag)

        super.mixListView(listView: listView, togetherWith: viewModel)
    }
}

public class ToastErrorRequestMixer: MGRxListWithApiMixer {
    override public func mixListView(listView: UIScrollView,
                                     togetherWith viewModel: HaveRequestRx) {
        guard let filterErrorViewModel = viewModel as? NeedHandleRequestError else {
            super.mixListView(listView: listView, togetherWith: viewModel)
            return
        }

        filterErrorViewModel.errorProvider
            .distinctRubbish()
            .bind(to: listView.rx.toastErrorOnMe)
            .disposed(by: listView.rx.disposeBag)

        super.mixListView(listView: listView, togetherWith: viewModel)
    }
}

public class CustErrorRequestMixer: MGRxListWithApiMixer {

    var errorAction: ErrorActionType!

    convenience public init(action : @escaping ErrorActionType) {
        self.init()
        errorAction = action
    }

    required override public init() {
        super.init()
    }

    override public func mixListView(listView: UIScrollView,
                                     togetherWith viewModel: HaveRequestRx) {
        guard let filterErrorViewModel = viewModel as? NeedHandleRequestError else {
            super.mixListView(listView: listView, togetherWith: viewModel)
            return
        }

        filterErrorViewModel.errorProvider
            .distinctRubbish()
            .subscribe(onNext: {[weak self] (error) in
                guard let strongSelf = self else { return }
                strongSelf.errorAction(error)
            })
            .disposed(by: listView.rx.disposeBag)

        super.mixListView(listView: listView, togetherWith: viewModel)
    }
}

public class PageRequestMixer: MGRxListWithApiMixer {
    override public func mixListView(listView: UIScrollView, togetherWith viewModel: HaveRequestRx) {
        guard let pageViewModel = viewModel as? PagableRequest else {
            super.mixListView(listView: listView, togetherWith: viewModel)
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
            .disposed(by: listView.rx.disposeBag)

        super.mixListView(listView: listView, togetherWith: viewModel)
    }
}
