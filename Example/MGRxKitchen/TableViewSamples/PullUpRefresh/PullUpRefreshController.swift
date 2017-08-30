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
}

extension PullUpRefreshController
{
    fileprivate func configRx()
    {
        dataRefresher
            .do(onNext: { (_) in
                print("start")
            })
            .flatMap { self.viewModel.serviceDriver }
            .do(onNext: { (_) in
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.endRefreshing()
            })
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) {
                (index, demo: Demo, cell) in
                cell.textLabel?.text = demo.name
            }.disposed(by: disposeBag)
        
        tableView.rx
            .pullUpRefreshing
            .bind(to: self.viewModel.nextPage)
            .disposed(by: disposeBag)
        

        tableView.rx.pullDownRefreshing
            .bind(to: self.viewModel.refreshPage)
            .disposed(by: self.disposeBag)
        
        Observable.merge([self.viewModel.nextPage,
                          self.viewModel.refreshPage])
            .bind(to: dataRefresher)
            .disposed(by: disposeBag)
    }
}
