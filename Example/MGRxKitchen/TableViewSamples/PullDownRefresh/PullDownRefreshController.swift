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
import MGRxKitchen
import MGRequest

class PullDownRefreshController: UIViewController {

    // MARK: - Xib items
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.smoothlyRegister(forType: TempTableViewCell.self)
        }

    }

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

        MGRxListWithApiMixer.createMixChain().mixView(view: tableView, togetherWith: viewModel)
    }
}

extension PullDownRefreshController {
    fileprivate func configRx() {
        dataRefresher
            .flatMap { self.viewModel.serviceDriver }
            .do(onNext: { (_) in
                self.tableView.mj_header.endRefreshing()
            })
            .checkEmptyList(emptyAction: {}, notEmptyAction: {})
            .smoothlyBind(to: tableView, by: { (_, demo, cell: TempTableViewCell) in
                cell.textLabel?.text = demo.name
            }).disposed(by: disposeBag)

        tableView.rx.pullDownRefreshing
            .bind(to: dataRefresher)
            .disposed(by: self.disposeBag)
    }
}
