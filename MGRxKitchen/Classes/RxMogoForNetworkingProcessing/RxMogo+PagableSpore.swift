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
public protocol PagableRequest : class
{
    // MARK: - Inputs
    /// 全部刷新，上拉或者刚进来什么的
    var firstPage : PublishSubject<Void> { get set }
    
    /// 下一页能量
    var nextPage : PublishSubject<Void> { get set }
    
    // MARK: - Outputs
    /// 获取page
    ///
    /// - Parameter request: pureRequest之类的
    /// - Returns: Observable T
    func pagedRequest<Element>(request : @escaping (MGPage) -> Observable<([Element] , MGPage)>)-> Observable<[Element]>
}

// MARK: - Page
public extension PagableRequest
{
    func pagedRequest<Element>(request : @escaping (MGPage) -> Observable<([Element] , MGPage)>)-> Observable<[Element]>
    {
        let loadNextPageTrigger: (Driver<MGPageRepositoryState<Element>>) -> Driver<()> =  { state in
            return self.nextPage.asDriver(onErrorJustReturn: ()).withLatestFrom(state).flatMap({ (state) -> Driver<()> in
                return !state.shouldLoadNextPage
                    ? Driver.just(())
                    : Driver.empty()
            })
        }
        
        return pagableRepository(allRefresher: firstPage.asDriver(onErrorJustReturn: ()), loadNextPageTrigger: loadNextPageTrigger) { (page) -> Observable<([Element] , MGPage )> in
                return request(page)
            }.asObservable()
            .map { $0.repositories }
            .map { $0.value }
    }
}
