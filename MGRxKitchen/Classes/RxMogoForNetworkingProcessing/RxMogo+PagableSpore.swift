//
//  RxMogo+PagableSpore.swift
//  Pods
//
//  Created by Harly on 2017/9/16.
//
//

import UIKit
import Result
import RxSwift
import RxCocoa
import MGBricks

/// 分页实现 
public protocol PagableRequest : class {
    // MARK: - Inputs
    /// 全部刷新，上拉或者刚进来什么的
    var firstPage: PublishSubject<Void> { get set }

    /// 下一页能量
    var nextPage: PublishSubject<Void> { get set }

    /// 最后一页超级能量
    var finalPageReached: PublishSubject<Void> { get set }

    // MARK: - Outputs
    /// 获取page
    ///
    /// - Parameter request: pureRequest之类的
    /// - Returns: Observable T
    func pagedRequest<Element>(request : @escaping (MGPage) -> Observable<Result<([Element], MGPage), MGAPIError>>)-> Observable<[Element]>
}

// MARK: - Page
public extension PagableRequest {
    func pagedRequest<Element>(request : @escaping (MGPage) -> Observable<Result<([Element], MGPage), MGAPIError>>)-> Observable<[Element]> {
        let loadNextPageTrigger: (Driver<MGPageRepositoryState<Element>>) -> Driver<()> = { state in
            return self.nextPage.asDriver(onErrorJustReturn: ()).withLatestFrom(state).do(onNext: { state in

                if let page = state.pageInfo ,
                    page.currentPage >= page.totalPage {
                    self.finalPageReached.onNext(())
                }

            }).flatMap({ state -> Driver<()> in
                !state.shouldLoadNextPage
                    ? Driver.just(())
                    : Driver.empty()
            })
        }

        return pagableRepository(allRefresher: firstPage.asDriver(onErrorJustReturn: ()),
                                 loadNextPageTrigger:
        loadNextPageTrigger) { page -> Observable<Result<([Element], MGPage), MGAPIError>> in
                return request(page)
            }.asObservable()
            .map { $0.repositories }
            .map { $0.value }
    }
}
