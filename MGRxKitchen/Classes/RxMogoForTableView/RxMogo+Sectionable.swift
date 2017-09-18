//
//  RxMogo+Sectionable.swift
//  Pods
//
//  Created by Harly on 2017/9/18.
//
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

/// MGSection model
public class MGSection<ItemElement>: SectionModelType {

    public typealias Item = ItemElement

    var header: String = ""

    public var items: [Item] = []

    init() {

    }

    public required init(original: MGSection, items: [Item]) {
        self.header = original.header
        self.items = items
    }

    /// 初始化调用我就行了
    ///
    /// - Parameters:
    ///   - header: header string
    ///   - items: items
    public convenience init(header: String, items: [Item]) {
        let section = MGSection<Item>()
        section.header = header
        section.items = items

        self.init(original: section, items: items)
        self.header = header

    }
}
