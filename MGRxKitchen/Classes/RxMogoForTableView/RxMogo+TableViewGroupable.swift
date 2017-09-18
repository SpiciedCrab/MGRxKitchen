//
//  RxMogo+TableViewGroupable.swift
//  Pods
//
//  Created by Harly on 2017/9/18.
//
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

public typealias DataSourceWithRequest<RowItem> = [MGSection<RowItem>]

// MARK: - Extension for section
public extension Observable {

    /// BindData to sectionable tableView
    ///
    /// - Parameters:
    ///   - tableView: tableView
    ///   - configCell: Config closure
    /**
        make the [MGSection<Item>()] to bind to the tableView.
     
        configureCell = { (dataSource, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(indexPath.row)"
            return cell
        }
     
     */
    func bind<RowItem>(to tableView : UITableView, by configCell : @escaping
        (TableViewSectionedDataSource<MGSection<RowItem>>,
        UITableView,
        IndexPath,
        RowItem) -> UITableViewCell )
        -> Disposable
        where E == DataSourceWithRequest<RowItem> {

        let realDataSource = RxTableViewSectionedReloadDataSource<MGSection<RowItem>>()

        realDataSource.titleForHeaderInSection = { ds, index in
                return ds.sectionModels[index].header
        }

        realDataSource.configureCell = configCell

        return self.bind(to: tableView.rx.items(dataSource: realDataSource))
    }
}
