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

    public var header: String = ""

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

/// 复杂的sectionModel
public class MGComplexSection<SectionElement, ItemElement>: SectionModelType {
    public var items: [ItemElement] = [ItemElement]()
    
    public typealias Item = ItemElement
    public var section: SectionElement?
    
    init() {
        //
    }
    public required init(original: MGComplexSection, items: [MGComplexSection.Item]) {
        self.section = original.section
        self.items = items
    }
    public convenience init(section: SectionElement, items: [MGComplexSection.Item]) {
        let complexSection = MGComplexSection<SectionElement, Item>()
        complexSection.section = section
        complexSection.items = items
        self.init(original: complexSection, items: items)
        self.section = section
    }
}
