//
//  ViewController.swift
//  RxMogo
//
//  Created by Harly on 2017/7/28.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    //MARK : - UIs
    
    //Label
    @IBOutlet weak var viewLabel: UILabel!
    
    //ButtonAction
    @IBOutlet weak var viewBtn: UIButton!
    
    //TextFied twoWayBinding
    @IBOutlet weak var searcTextField: UITextField!
    
    
    let disposeBag = DisposeBag()
    
//    let vm = ViewModel()

    //MARK : - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Button
//        viewBtn.rx.tap.bind(to: vm.confirmAction).disposed(by: disposeBag)
        
        //Label
//        vm.displayBindableNum
//            .asDriver()
//            .map { "\($0)" }
//            .drive(viewLabel.rx.text)
//            .disposed(by: disposeBag)
        
        //TextField (这边用了偷懒的方法，有兴趣可以进 <-> 看看，其实就是正向来一发，反向再来一次）
//        (searcTextField.rx.text <-> vm.searchText).disposed(by: disposeBag)
        
        //TextField 这是Enable控制的
//        vm.displayBindableNum
//            .asDriver()
//            .map( { $0 % 2 == 0 })
//            .drive(searcTextField.rx.isEnabled)
//            .disposed(by: disposeBag)
//        
    }
}

