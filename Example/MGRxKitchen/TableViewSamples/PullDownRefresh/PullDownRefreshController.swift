//
//  PullDownRefreshController.swift
//  RxMogo
//
//  Created by Harly on 2017/8/16.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh

class PullDownRefreshController: UIViewController {
    
    // MARK: - Xib items
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private items
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let dataRefresher = PublishSubject<Void>()
    
    let viewModel = TableViewTestViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.initial()
        
        configRx()
        
        /// 初始刷新呐
        tableView.mj_header.beginRefreshing()
    }
}

extension PullDownRefreshController
{
    fileprivate func configRx()
    {
        dataRefresher
            .flatMap { self.viewModel.serviceDriver }
            .do(onNext: { (_) in
                self.tableView.mj_header.endRefreshing()
            })
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) {
                (index, demo: Demo, cell) in
                cell.textLabel?.text = demo.name
        }.disposed(by: disposeBag)
        
        tableView.rx.pullDownRefreshing
            .bind(to: dataRefresher)
            .disposed(by: self.disposeBag)
    }
}
