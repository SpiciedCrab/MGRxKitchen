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
import MGUIKit
import MGRxKitchen
import MGRequest

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
//
//        requestBtn.rx.tap.map { () }
//            .bind(to : tableView.rx.makMePullDown)
//            .disposed(by: disposeBag)

        MGRxListWithApiMixer.createMixAlertChain().mixView(view: view, togetherWith: viewModel)

        viewModel.serviceDriver.bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) {
            (_, demo: Demo, cell) in
            cell.textLabel?.text = "\(demo.name)"
            }.disposed(by: disposeBag)

        //
        requestBtn.rx.tap
            .map {}.subscribe(onNext: { (_) in
                MGSwiftAlertCenter.showLazyTitleAlert("alert", message: "ss", cancelString: nil, actionTitleArr: ["请求他丫的"], complexMode: true, actionBlock: { (_) in
                    self.viewModel.firstPage.onNext(())
                })
            })
            .disposed(by: disposeBag)

//        tableView.mj_header.beginRefreshing()
    }
}
