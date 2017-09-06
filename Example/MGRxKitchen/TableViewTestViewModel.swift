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
import MGBricks
import Result

class TableViewTestViewModel : HaveRequestRx , PagableRequest
{
    var loadingActivity: ActivityIndicator = ActivityIndicator()

    var errorProvider : PublishSubject<RxMGError> = PublishSubject<RxMGError>()
    
    let disposeBag = DisposeBag()
    
    let service = MockService()
    
    let nextPage = PublishSubject<Bool>()
    
    let refreshPage = PublishSubject<Void>()
    
    var serviceDriver : Observable<[Demo]>!
    
    var intServDriver : Observable<[Int]>!
    
    init() {
        
    }
    
    func initial()
    {
        let originResult = self.pagedRequest(withResultSignal: { (page) -> Observable<Result<([Demo], MGPage), MGAPIError>> in
            return self.service.provideMock(on: page)
        }, withFlag: nil, withTrigger: self.nextPage.map { _ in () }.asObservable())

        serviceDriver = originResult.scan([], accumulator: { (preDemos, demos) -> [Demo] in
            var newDemos = [Demo]()
            newDemos.append(contentsOf: preDemos)
            newDemos.append(contentsOf: demos)
            return newDemos
        })
        
        
        
//        intServDriver = Observable.page(make: { (_) -> Observable<[Int]> in
//            return Observable.of([0,1,2,3,4,5])
//        }, while: { (_) -> Bool in
//            return true
//        }, when: self.nextPage.asObservable()).scan([], accumulator: +)
        
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
        
//        nextPage.subscribe(onNext: { (_) in
//            self.page.currentPage = self.page.currentPage + 1
//        })
        
//        refreshPage.map { 0 }.bind(to: page).disposed(by: disposeBag)
    }
    
    
}
