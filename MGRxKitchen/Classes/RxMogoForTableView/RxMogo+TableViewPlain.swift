//
//  RxMogo+TableViewPlain.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/11/13.
//

import Foundation
import RxCocoa
import RxSwift

extension Observable where Element : Collection {

    /// Binding
    ///
    /// - Parameters:
    ///   - tableView: tableView
    ///   - configCell: {(path, demo) in
    //       let cell = smoothlyDequexxxxx
    ///      cell.textLabel?.text = demo.name}
    ///      return cell
    ///   }
    /// - Returns: dispose
    public func smoothlyBind(to tableView: UITableView, by configCell : @escaping
        (IndexPath, E.Iterator.Element) -> UITableViewCell )
        -> Disposable {

            return self.bind(to: tableView.rx.items) { (_, row, element: E.Iterator.Element) in
                return configCell(IndexPath(row: row, section: 0), element)
            }
    }

    /// Binding
    ///
    /// - Parameters:
    ///   - tableView: tableView
    ///   - configCell: {(path, demo, cell: TempTableViewCell) in
    ///      cell.textLabel?.text = demo.name}
    ///   }
    /// - Returns: dispose
    public func smoothlyBind<Cell: UITableViewCell>(to tableView: UITableView, by configCell :        @escaping (IndexPath, E.Iterator.Element, Cell) -> Void )
        -> Disposable {
        return bind(to: tableView.rx
            .items(cellIdentifier: Cell.reuseIdentifier)) {(path, item: E.Iterator.Element, cell) in
                configCell(IndexPath(row: path, section: 0), item, cell)
        }
    }

}
