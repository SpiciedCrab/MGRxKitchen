//
//  TableViewTestViewModel.swift
//  RxMogo
//
//  Created by Harly on 2017/8/7.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxSwiftUtilities
import MGRxKitchen

class TableViewTestViewModel : HaveRequestRx , NeedHandleRequestError
{
    var loadingActivity: ActivityIndicator = ActivityIndicator()

    var errorProvider : PublishSubject<RxMGError> = PublishSubject<RxMGError>()
    
    let disposeBag = DisposeBag()
    
    let service = MockService()
    
    let page = Variable<Int>(0)
    
    let nextPage = PublishSubject<Void>()
    
    let refreshPage = PublishSubject<Void>()
    
    var serviceDriver : Observable<[Demo]>!
    
    var finalDemos = [Demo]()
    
    init() {
        
    }
    
    func initial()
    {
        let originResult = page.asObservable().flatMap { self.requestAfterErrorFilterd(withResultSignal: self.service.provideMock(on: $0)) }
        
        serviceDriver = originResult.map { (demos) -> [Demo] in
            if self.page.value == 0
            {
                self.finalDemos = demos
            }
            else
            {
                self.finalDemos.append(contentsOf: demos)
            }
            return self.finalDemos
        }
        
        //        serviceDriver = page.asObservable().flatMap{ self.service.provideMock(on: $0).map({ demo -> [Demo] in
//            if self.page.value == 0
//            {
//                self.finalDemos = demo
//            }
//            else
//            {
//                self.finalDemos.append(contentsOf: demos)
//            }
//            
//            return self.finalDemos
//        }) }
        
        nextPage.map { self.page.value + 1 }.bind(to: page).disposed(by: disposeBag)
        
        refreshPage.map { 0 }.bind(to: page).disposed(by: disposeBag)
    }
    
    
}
