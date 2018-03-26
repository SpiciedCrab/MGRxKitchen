//
//  RxMogo+ObservableMapping.swift
//  Pods
//
//  Created by Harly on 2017/8/27.
//
//

import UIKit
import MGRequest
import RxCocoa
import RxSwift
import HandyJSON

// MARK: - Observable json转化
// swiftlint:disable syntactic_sugar
public extension Observable where Element == Dictionary<String, Any> {
    /// 把你的Response变成model啦
    ///
    /// - Returns: 砖头
    func mapBricks<ModelElement: HandyJSON>() -> Observable<ModelElement> {
        return map { ModelElement.deserialize(from: $0 as NSDictionary) ?? ModelElement() }
    }
}

// MARK: - Observable array转化
public extension Observable where Element == Array<[String: Any]> {
    /// 把你的[Json]变成[model]啦
    ///
    /// - Returns: 砖头
    func mapBricks<ModelElement: HandyJSON>() -> Observable<[ModelElement]> {

        return map { arrJson  in
            if let models =  [ModelElement].deserialize(from: arrJson as NSArray ) as? [ModelElement] {
                return models
            }
            return [ModelElement]()
        }
    }
}

// MARK: - 砖头转化
public extension Observable where Element == RxBricks<Array<[String: Any]>> {
    /// 把你的[Json]变成[model]啦
    ///
    /// - Returns: 砖头
    func mapBricks<ModelElement: HandyJSON>() -> Observable<[ModelElement]> {

        return map { ele  in

            switch ele {
                case .finished(let arrJson):

                    if let models =  [ModelElement].deserialize(from: arrJson as NSArray ) as? [ModelElement] {
                        return models
                    }
                    return [ModelElement]()

                default:
                    return []
            }
        }
    }
}

// MARK: - Error能量去重复，防止真的error和emptyMessage一起来
public extension PublishSubject where Element == RxMGError {
    /// 把后来的emtpyMessage去掉
    ///
    /// - Returns: realToBind
    func distinctRubbish() -> Observable<Element> {
        return distinctUntilChanged({ error1, error2 -> Bool in
            error1.apiError.code != error2.apiError.code && error2.apiError.code ?? "" == emptyMessageErrorCode
        })
    }
}
