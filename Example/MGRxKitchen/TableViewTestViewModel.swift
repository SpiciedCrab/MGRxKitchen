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
import MGRxActivityIndicator
import MGRxKitchen
import MGBricks
import Result

internal class MGItem {
    var name: String = ""

    init(str: String) {
        name = str
    }
}

internal class TableViewTestViewModel: HaveRequestRx, PagableRequest, PagableWings {

    typealias PageJSONType = SuperDemo

    var jsonOutputer: PublishSubject<SuperDemo> = PublishSubject<SuperDemo>()

    var loadingActivity: ActivityIndicator = ActivityIndicator()

    var errorProvider: PublishSubject<RxMGError> = PublishSubject<RxMGError>()

    var firstPage: PublishSubject<Void> = PublishSubject()

    var nextPage: PublishSubject<Void> = PublishSubject()

    //Output
    var finalPageReached: PublishSubject<Void> = PublishSubject()

    let disposeBag: DisposeBag = DisposeBag()

    let service: MockService = MockService()

    var serviceDriver: Observable<[Demo]>!

    init() {

    }

    func initial() {

//        pagedRequest(request: <#T##(MGPage) -> Observable<Result<([Element], MGPage), MGAPIError>>#>)
//        let requestObser: Observable<Result<([Demo], MGPage), MGAPIError>> = interuptPage(origin: self.service.providePageJSONMock(on: 1)) { json -> [Demo] in
//            return json.demos
//        }
//
//        serviceDriver = pagedRequest(request: { _ in requestObser })

        serviceDriver = pagedRequest(request: { page -> Observable<Result<([String : Any], MGPage), MGAPIError>> in
            return self.service.providePageJSONMock(on: page.currentPage)
        }) { json -> [Demo] in
            return json.demos
        }
    }

    func sectionableData() -> Observable<[MGSection<MGItem>]> {
        let item1 = MGItem(str: "1")
        let item2 = MGItem(str: "2")
        let item3 = MGItem(str: "4")
        let item4 = MGItem(str: "5")

        let section1 = MGSection(header: "header1", items: [item1, item2])
        let section2 = MGSection(header: "header2", items: [item3, item4])

        return Observable.of([section1, section2])

    }

}
