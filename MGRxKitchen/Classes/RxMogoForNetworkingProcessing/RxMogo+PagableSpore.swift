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
public protocol PagableRequest: NeedHandleRequestError, HaveRequestRx {
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

        let performSearch: ((MGPage) -> Observable<PageResponse<Element>>) = {[weak self] page -> Observable<Result<([Element], MGPage), MGAPIError>> in
            guard let strongSelf = self else { return Observable.empty() }
            return strongSelf.trackRequest(signal: request(page))
        }

        let repo = pagableRepository(allRefresher: firstPage.asDriver(onErrorJustReturn: ()),
                                     loadNextPageTrigger: loadNextPageTrigger,
                                     performSearch: performSearch) {[weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.errorProvider
                .onNext(RxMGError(identifier: "pageError", apiError: error))
        }
        return repo.asObservable()
            .map { $0.repositories }
            .map { $0.value }
    }
}
