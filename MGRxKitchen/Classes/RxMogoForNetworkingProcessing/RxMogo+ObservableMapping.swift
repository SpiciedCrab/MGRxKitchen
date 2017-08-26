//
//  RxMogo+ObservableMapping.swift
//  Pods
//
//  Created by Harly on 2017/8/27.
//
//

import UIKit
import MGBricks
import RxCocoa
import RxSwift
import HandyJSON

// MARK: - Observable model转化
public extension Observable where Element == MGResponse
{
    /// 把你的Response变成model啦
    ///
    /// - Returns: 砖头
    func mapBricks<ModelElement : HandyJSON>() -> Observable<ModelElement>
    {
        return map { ModelElement.deserialize(from: $0.content as NSDictionary) ?? ModelElement() }
    }
}
