//
//  RxMogo+UITextField.swift
//  MGRxKitchen
//
//  Created by guanxiaobai on 09/12/2017.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base: UITextField {
    public var placeholder: Binder<String> {
        return Binder(self.base, binding: { (tf, str) in
            tf.placeholder = str
        })
    }
    public var text: Binder<String> {
        return Binder(self.base, binding: { (tf, str) in
            tf.text = str
        })
    }
}
