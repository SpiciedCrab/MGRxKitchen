//
//  RxMogo+Text.swift
//  MGRxKitchen
//
//  Created by Harly on 2018/1/10.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UITextView {
    /// Reactive wrapper for `text` property
    /// 这个只会跟踪真正输到屏幕里的字，键盘上打的不会触发哟
    public var realtext: ControlProperty<String?> {

        text.asControlProperty()
        let source: Observable<String?> = text.asObservable().map { (_) -> String? in
            if let positionRange = self.base.markedTextRange {
                if let _ = self.base.position(from: positionRange.start, offset: 0) {
                    //正在使用拼音，不进行校验
                    return nil
                }
            }
            //不在使用拼音，进行校验
            return self.base.text
            }.filter { $0 != nil }

        let bindingObserver = Binder(self.base) { (textView, text: String?) in
            if textView.text != text {
                textView.text = text
            }
        }

        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}

extension Reactive where Base: UITextField {
    /// Reactive wrapper for `text` property
    public var realtext: ControlProperty<String?> {

        /// 这个只会跟踪真正输到屏幕里的字，键盘上打的不会触发哟
        let source: Observable<String?> = text.asObservable().map { (_) -> String? in
            if let positionRange = self.base.markedTextRange {
                if let _ = self.base.position(from: positionRange.start, offset: 0) {
                    //正在使用拼音，不进行校验
                    return nil
                }
            }
            //不在使用拼音，进行校验
            return self.base.text
            }.filter { $0 != nil }

        let bindingObserver = Binder(self.base) { (textView, text: String?) in
            if textView.text != text {
                textView.text = text
            }
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }

    public var placeholder: Binder<String> {
        return Binder(self.base, binding: { tf, str in
            tf.placeholder = str
        })
    }
}
