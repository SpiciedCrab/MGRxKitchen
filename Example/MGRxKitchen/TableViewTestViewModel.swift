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
    
    var serviceDriver : Observable<[Demo]>!
    
    var firstPage : PublishSubject<Void> = PublishSubject()
    
    var nextPage : PublishSubject<Void> = PublishSubject()
    
    init() {
        
    }
    
    func initial()
    {
        serviceDriver = pagedRequest(request: { (page) -> Observable<([Demo], MGPage)> in
            return self.pureRequest(withResultSignal: self.service.provideMock(on: page.currentPage + 1))
        })
        
    }
    
}
