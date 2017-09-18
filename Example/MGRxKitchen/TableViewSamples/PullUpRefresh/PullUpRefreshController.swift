//
//  PullUpRefreshController.swift
//  RxMogo
//
//  Created by Harly on 2017/8/16.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh

class PullUpRefreshController: UIViewController {
    @IBOutlet weak var barItem: UIBarButtonItem!

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
    }

    @IBOutlet weak var requestBtn: UIButton!
}

extension PullUpRefreshController {
    fileprivate func configRx() {

        requestBtn.rx.tap.map { () }
            .bind(to : tableView.rx.makMePullDown)
            .disposed(by: disposeBag)

        tableView.rx.pullDownRefreshing
            .bind(to: self.viewModel.firstPage)
            .disposed(by: self.disposeBag)
        //
        tableView.rx
            .pullUpRefreshing
            .bind(to: self.viewModel.nextPage)
            .disposed(by: disposeBag)

        //        Observable.merge([self.viewModel.nextPage])
        //            .bind(to: dataRefresher)
        //            .disposed(by: disposeBag)

        viewModel.loadingActivity.asObservable().filter { !$0 }.subscribe(onNext: { (_) in

            self.tableView.mj_header.endRefreshing()

            if self.tableView.mj_footer != nil {
                self.tableView.mj_footer.endRefreshing()
            }
        }).disposed(by: disposeBag)

        viewModel.finalPageReached.subscribe(onNext: { (_) in
            if self.tableView.mj_footer != nil {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }).disposed(by: disposeBag)

        viewModel.serviceDriver.bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) {
            (_, demo: Demo, cell) in
            cell.textLabel?.text = "\(demo.name)"
            }.disposed(by: disposeBag)

        //

//        tableView.mj_header.beginRefreshing()
    }
}
