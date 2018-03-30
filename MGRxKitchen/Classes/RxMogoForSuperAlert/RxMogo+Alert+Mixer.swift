//
//  RxMogo+Alert+Mixer.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/12/18.
//

import Foundation
import RxSwift
import MGUIKit
import NSObject_Rx
import MGRequest
import MGCore

// MARK: - 为了Alert做的Vip
extension MGRxListWithApiMixer {

    /// 创建一个alert全家桶
    ///
    /// - Returns: mixer
    public class func createMixAlertChain() -> MGRxListWithApiMixer {
        return MGRxListWithApiMixer.createMixChain(errorType: .onView, mixerReformer: { (_) -> [MGRxListWithApiMixer.Type] in
            return [AlertDefaultRequestMixer.self,
                    AlertErrorRequestMixer.self]
        })
    }
}

// MARK: - Alert特有的搅拌器款
/// 处理了alert的loading
internal class AlertDefaultRequestMixer: MGRxListWithApiMixer {
    override public func mixView(view: UIView,
                                 togetherWith viewModel: HaveRequestRx) {
        viewModel.loadingActivity
            .asObservable()
            .subscribe(onNext: { isLoading in
                if isLoading {
                    MGSwiftAlertCenter.switchStatus(.loadingProcessing(processingMessage: "处理中"))
                } else {
                    MGSwiftAlertCenter.switchStatus(.loadingSuccess(successMessage: "处理成功"))
                }
            })
            .disposed(by: view.rx.disposeBag)
    }
}

/// alert变成failed
public class AlertErrorRequestMixer: MGRxListWithApiMixer {
    override public func mixView(view: UIView,
                                 togetherWith viewModel: HaveRequestRx) {
        guard let filterErrorViewModel = viewModel as? NeedHandleRequestError else {
            super.mixView(view: view, togetherWith: viewModel)
            return
        }

        filterErrorViewModel.errorProvider
            .distinctRubbish()
            .subscribe(onNext: { (error: RxMGError) in
                MGSwiftAlertCenter.switchStatus(.loadingFailed(failedMessage: error.apiError.message))
            })
            .disposed(by: view.rx.disposeBag)

        super.mixView(view: view, togetherWith: viewModel)
    }
}
