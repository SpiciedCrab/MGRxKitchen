//
//  ActorLoadingRxExtensions.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/10/19.
//

import Foundation
import ActionStageSwift
import RxSwift
import RxCocoa

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

extension LHWActor : ReactiveCompatible {  }
extension LHWActionStage : ReactiveCompatible {  }
