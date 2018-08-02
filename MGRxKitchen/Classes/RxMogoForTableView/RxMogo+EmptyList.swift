//
//  RxMogo+EmptyList.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/10/11.
//

import Foundation
import RxCocoa
import RxSwift

public extension Observable where Element : Collection {
    
    /// 查看是不是空的
    ///
    /// - Parameters:
    ///   - emptyAction: empty
    ///   - notEmptyAction: not empty
    /// - Returns: 啦啦啦
    func checkEmptyList(emptyAction : @escaping () -> Void ,
                        notEmptyAction : @escaping () -> Void)
        -> Observable {
        return self.do(onNext: { items in
            if items.isEmpty {
                emptyAction()
            } else {
                notEmptyAction()
            }
        })
    }
}
