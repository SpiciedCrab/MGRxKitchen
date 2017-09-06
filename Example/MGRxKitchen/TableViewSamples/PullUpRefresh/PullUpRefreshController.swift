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
}

extension PullUpRefreshController
{
    fileprivate func configRx()
    {
//        dataRefresher
//            .do(onNext: { (_) in
//                print("start")
//            })
//            .flatMap { self.viewModel.serviceDriver }
//            .do(onNext: { (_) in
//                self.tableView.mj_footer.endRefreshing()
//                self.tableView.mj_header.endRefreshing()
//            })
//            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) {
//                (index, demo: Demo, cell) in
//                cell.textLabel?.text = demo.name
//            }.disposed(by: disposeBag)
//        
//        tableView.rx
//            .pullUpRefreshing
//            .map { true }
//            .bind(to: self.viewModel.nextPage)
//            .disposed(by: disposeBag)
        

//        barItem.rx.tap.bind(to: self.viewModel.nextPage)
//            .disposed(by: disposeBag)
        
        tableView.rx.pullDownRefreshing.map { false }
            .bind(to: self.viewModel.nextPage)
            .disposed(by: self.disposeBag)
//
//        Observable.merge([self.viewModel.nextPage])
//            .bind(to: dataRefresher)
//            .disposed(by: disposeBag)
        
        viewModel.serviceDriver.do(onNext: { (_) in
            self.tableView.mj_footer.endRefreshing()
            self.tableView.mj_header.endRefreshing()
        }).bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) {
            (index, demo: Demo, cell) in
            cell.textLabel?.text = "\(demo.name)"
            }.disposed(by: disposeBag)
        
        tableView.rx
            .pullUpRefreshing.map { true }
            .bind(to: self.viewModel.nextPage)
            .disposed(by: disposeBag)
//
    }
}
