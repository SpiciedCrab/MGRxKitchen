//
//  ButtonRefreshController.swift
//  RxMogo
//
//  Created by Harly on 2017/8/16.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh
import MGBricks

class ButtonRefreshController: UIViewController {

    // MARK: - Xib items
    @IBOutlet weak var refreshBtn: UIBarButtonItem!

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
        dataRefresher.onNext(())

    }
}

extension ButtonRefreshController {
    fileprivate func configRx() {

//        viewModel.loadingActivity
//            .asObservable()
//            .bind(to: self.tableView.rx.isLoadingOnMe)
//            .disposed(by: disposeBag)

        viewModel
            .errorProvider
            .bind(to: self.tableView.rx.toastErrorOnMe)
            .disposed(by: self.disposeBag)

        dataRefresher.flatMap { self.viewModel.serviceDriver }
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) {
                (_, demo: Demo, cell) in
                cell.textLabel?.text = demo.name
            }
            .disposed(by: self.disposeBag)

        refreshBtn.rx.tap
            .bind(to : dataRefresher)
            .disposed(by: disposeBag)
    }
}
