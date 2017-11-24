//
//  ActorLoadingRxExtensions.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/10/19.
//

import MGRxKitchen
import MGProgressHUD
import MGRxActivityIndicator
import RxSwift
import RxCocoa
import MGActionStageSwift

// MARK: - 发送一个Message to watchers
extension Reactive where Base : LHWActionStage {
    public var aoeMessageToWatchers: UIBindingObserver<Base, [String]> {

        return UIBindingObserver(UIElement: base, binding: { (_, paths) in

            paths.forEach({ (path) in
                self.base.dispatchMessageToWatchers(path: path, messageType: nil, message: nil)
            })

        })
    }
}

// MARK: - LHWActors 的能量接受者
extension Reactive where Base : LHWActor {

    /// 让actor中所有watchers都失败
    public var failedToAll: UIBindingObserver<Base, [String]> {

        return UIBindingObserver(UIElement: base, binding: { (_, paths) in

            paths.forEach({ (path) in

                ActionStageInstance.actionFailed(path, reason: .failed)
            })

        })
    }
}

// MARK: - 配置Actor的Rxs
public protocol MGActorLoadingAvailable {
    var loadingActivity: ActivityIndicator { get set }

    /// 错误能量之源呐
    var errorProvider: PublishSubject<RxMGError> { get set }

    var disposeBag: DisposeBag { get set }
}

extension MGActorLoadingAvailable where Self : LHWActor {
    public func configLoading() {
        errorProvider.do(onNext: { error in
            MGProgressHUD.showTextAndHiddenView(error.apiError.message)
        }).map { _ in [self.path] }
            .bind(to: rx.failedToAll)
            .disposed(by: disposeBag)

        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }

        loadingActivity
            .asObservable()
            .bind(to: vc.view.rx.isLoading)
            .disposed(by: disposeBag)
    }
}

extension LHWActor : ReactiveCompatible {  }
extension LHWActionStage : ReactiveCompatible {  }
