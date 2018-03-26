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
import MGRequest
import HandyJSON

public protocol PageBase: NeedHandleRequestError, HaveRequestRx {
    // MARK: - Inputs
    /// 全部刷新，上拉或者刚进来什么的
    var firstPage: PublishSubject<Void> { get set }

    /// 下一页能量
    var nextPage: PublishSubject<Void> { get set }

    /// 最后一页超级能量
    var finalPageReached: PublishSubject<Void> { get set }

    func basePagedRequest<Element>(request : @escaping (MGPage) -> Observable<Result<([Element], MGPage), MGAPIError>>)-> Observable<[Element]>
}

extension PageBase {

    public func basePagedRequest<Element>(request : @escaping (MGPage) -> Observable<Result<([Element], MGPage), MGAPIError>>)-> Observable<[Element]> {
        return base(request: request)
    }

    func base<Element>(request : @escaping (MGPage) -> Observable<Result<([Element], MGPage), MGAPIError>>)-> Observable<[Element]> {
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
            .do(onNext: { element in
                print(element)
            })
            .map { $0.repositories }
            .map { $0.value }
    }
}

/// 分页实现 
public protocol PagableRequest: PageBase {

    // MARK: - Outputs
    /// 获取page
    ///
    /// - Parameter request: pureRequest之类的
    /// - Returns: Observable T
    func pagedRequest<Element>(request : @escaping (MGPage) -> Observable<Result<([Element], MGPage), MGAPIError>>)-> Observable<[Element]>
}

// MARK: - Page
public extension PagableRequest {

    public func pagedRequest<Element>(request : @escaping (MGPage) -> Observable<Result<([Element], MGPage), MGAPIError>>)-> Observable<[Element]> {
        return basePagedRequest(request: request)
    }
}

/// Page Extension
public protocol PageableJSONRequest: PageBase {
    associatedtype PageJSONType

    /// 整个请求对象类型
    var jsonOutputer: PublishSubject<PageJSONType> { get set }
}

extension PageableJSONRequest {

    /// page请求究极体
    ///
    /// - Parameters:
    ///   - request: 你的request
    ///   - resolver: resolver，告诉我你的list是哪个
    /// - Returns: 原来的Observer
    public func pagedRequest<Element>(
        request : @escaping (MGPage) -> Observable<Result<([String: Any], MGPage), MGAPIError>>,
        resolver : @escaping (PageJSONType) -> [Element])
        -> Observable<[Element]> where PageJSONType: HandyJSON {
            func pageInfo(page: MGPage)
                -> Observable<Result<([Element], MGPage), MGAPIError>> {
                    let pageRequest = request(page).map({[weak self] result -> Result<([Element], MGPage), MGAPIError> in
                        guard let strongSelf = self else { return
                            Result(error: MGAPIError("000", message: "")) }
                        switch result {
                        case .success(let obj) :
                            let pageObj = PageJSONType.deserialize(from: obj.0 as NSDictionary) ?? PageJSONType()
                            let pageArray = resolver(pageObj)
                            strongSelf.jsonOutputer.onNext(pageObj)

                            return Result(value: (pageArray, obj.1))
                        case .failure :
                            return Result(error: result.error ??
                                MGAPIError("000", message: "不明错误出现咯"))
                        }
                    })

                    return pageRequest
            }

            return basePagedRequest(request: { page -> Observable<Result<([Element], MGPage), MGAPIError>> in
                return pageInfo(page: page)
            })
    }

}

/// Page Extension
public protocol PageExtensible: class {

    var pageOutputer: PublishSubject<MGPage> { get set }
}

extension PageBase where Self : PageExtensible {

    public func basePagedRequest<Element>(request : @escaping (MGPage) -> Observable<Result<([Element], MGPage), MGAPIError>>)-> Observable<[Element]> {
        func pageInfo(page: MGPage)
            -> Observable<Result<([Element], MGPage), MGAPIError>> {
                let pageRequest = request(page).map({[weak self] result -> Result<([Element], MGPage), MGAPIError> in
                    guard let strongSelf = self else { return
                        Result(error: MGAPIError("000", message: "")) }
                    switch result {
                    case .success(let obj) :
                        strongSelf.pageOutputer.onNext(obj.1)

                        return Result(value: (obj.0, obj.1))
                    case .failure :
                        return Result(error: result.error ??
                            MGAPIError("000", message: "不明错误出现咯"))
                    }
                })

                return pageRequest
        }

        return base(request: { page -> Observable<Result<([Element], MGPage), MGAPIError>> in
            return pageInfo(page: page)
        })
    }
}
