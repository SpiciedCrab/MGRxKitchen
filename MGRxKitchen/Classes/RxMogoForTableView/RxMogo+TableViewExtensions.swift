//
//  RxMogo+TableViewExtensions.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/11/14.
//

import UIKit

// MARK: - 一些不想引用的方法
internal func rxBundle(for aClass: Swift.AnyClass,
                       withResource name: String?) -> Bundle? {
    var bundle: Bundle?
    if let pathBundle = Bundle(for: aClass)
        .path(forResource: name ?? "Resources", ofType: "bundle") {
        bundle = Bundle(path: pathBundle)
    }
    if bundle == nil {
        bundle = Bundle(for: aClass)
    }
    return bundle
}

func nameForClass(classObj : Any) -> String {
    return String(describing: classObj)
}

// MARK: - UIView 扩展
extension UIView {

    public static var reuseIdentifier: String {
        return nameForClass(classObj: self)
    }

    public static var nibName: String {
        return nameForClass(classObj: self)
    }

}

// MARK: - TableView的注册和获取Cell
extension UITableView {

    /// Register Cell
    ///
    /// - Parameters:
    ///   - type: cell型
    ///   - resource: 可选
    public func smoothlyRegister<Cell: UITableViewCell>(forType type: Cell.Type ,
                                                        inResources resource: String? = nil) {
        let nib = UINib(nibName: Cell.nibName,
                        bundle: rxBundle(for: Cell.self,
                                         withResource: resource))
        register(nib, forCellReuseIdentifier: Cell.reuseIdentifier)
    }

    /// 获取一个cell
    ///
    /// - Parameter indexPath: path
    /// - Returns: cell
    public func smoothlyDequeueCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier,
                                             for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.reuseIdentifier)")
        }
        return cell
    }
}

// MARK: - UICollectionView的注册和获取Cell
extension UICollectionView {
    
    /// Register Cell
    ///
    /// - Parameters:
    ///   - type: cell型
    ///   - resource: 可选
    public func smoothlyRegister<Cell: UICollectionViewCell>(forType type: Cell.Type ,
                                                             inResources resource: String? = nil) {
        let nib = UINib(nibName: Cell.nibName, bundle: rxBundle(for: Cell.self,
                                                                withResource: resource))
        register(nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }

    /// 获取一个cell
    ///
    /// - Parameter indexPath: path
    /// - Returns: cell
    public func smoothlyDequeueCell<Cell: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.reuseIdentifier)")
        }
        return cell
    }
}
