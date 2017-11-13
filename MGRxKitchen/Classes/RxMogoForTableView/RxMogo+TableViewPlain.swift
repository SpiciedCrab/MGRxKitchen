//
//  RxMogo+TableViewPlain.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/11/13.
//

import Foundation
import RxCocoa
import RxSwift

public extension Observable where Element : Collection {

    func smoothlyBind(to tableView: UITableView, by configCell : @escaping
        (IndexPath, E.Iterator.Element) -> UITableViewCell )
        -> Disposable {

            return self.bind(to: tableView.rx.items) { (_, row, element: E.Iterator.Element) in
                return configCell(IndexPath(row: row, section: 0), element)
            }
    }

    func smoothlyBind<Cell: UITableViewCell>(to tableView: UITableView, by configCell :        @escaping (IndexPath, E.Iterator.Element, Cell) -> Void )
        -> Disposable {
        return bind(to: tableView.rx
            .items(cellIdentifier: Cell.description())) {(path, item: E.Iterator.Element, cell) in
                configCell(IndexPath(row: path, section: 0), item, cell)
        }
    }

}
