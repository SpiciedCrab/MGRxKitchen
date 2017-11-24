//
//  SectionableViewController.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/9/18.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

internal class SectionableViewController: UIViewController {

    let viewModel: TableViewTestViewModel = TableViewTestViewModel()

    let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel
            .sectionableData().checkEmptyList(emptyAction: {}, notEmptyAction: {})
            .bind(to: tableView) { (_, tableView, _, item) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                cell?.textLabel?.text = item.name
                return cell!
        }.disposed(by: disposeBag)

        tableView.rx
            .modelSelected(MGItem.self)
            .bind(to: self.rx.selectedMGItem)
            .disposed(by: disposeBag)

        tableView.delegate = self

    }

    @IBOutlet private weak var tableView: UITableView!
}

extension Reactive where Base : SectionableViewController {
    var selectedMGItem: UIBindingObserver<Base, MGItem> {

        return UIBindingObserver(UIElement: self.base, binding: { (_, item) in
            print(item.name + " selected ")
        })
    }
}

extension SectionableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
