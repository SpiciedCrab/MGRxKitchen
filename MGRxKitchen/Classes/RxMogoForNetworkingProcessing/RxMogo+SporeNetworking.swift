//
//  RxMogo+SporeNetworking.swift
//  RxMogo
//
//  Created by Harly on 2017/8/26.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Result
import MGBricks
import RxSwiftUtilities

//MARK: - RxMogo自定义Error
public struct RxMGError
{
    /// 标识
    public var identifier : String?
    
    /// Error
    public var apiError : MGAPIError
}

//这是个有请求就必须带着的协议哟
//MARK: - RxMogoRequest协议
public protocol HaveRequestRx : class
{
    /// 获取一个纯洁的请求，请求Error是不会走下去的，只会走成功的情况
    ///
    /// - Parameter requestSignal: Wings层来的请求
    /// - Returns: 你想要的请求砖头
    func pureRequest<Element>(withResultSignal requestSignal : Observable<Result<Element,MGAPIError>>) -> Observable<Element>
    
    var loadingActivity : ActivityIndicator { get set }
}


// HaveRequestRx 实现咯
public extension HaveRequestRx
{
    func pureRequest<Element>(withResultSignal requestSignal : Observable<Result<Element,MGAPIError>>) -> Observable<Element>
    {
        return trackRequest(signal: requestSignal)
            .filter({ (result) -> Bool in
            switch result
            {
            case .success :
                 return true
            case .failure :
                return false
            }
        }).map { (result) -> Element? in
            switch result
            {
            case .success (let obj):
                return obj
                
            default:
                return nil
            }
        }.map { $0! }
    }
    
    
    /// 跟踪某个请求
    ///
    /// - Parameter signal: 信号
    /// - Returns: 原封不动还给你
    func trackRequest<Element>(signal : Observable<Result<Element,MGAPIError>>) -> Observable<Result<Element,MGAPIError>>
    {
        return signal
            .trackActivity(self.loadingActivity)
    }
}

//如果你想处理错误，那就一起接上他咯
//MARK: - RxMogo Error Handle协议
public protocol NeedHandleRequestError
{
    /// 错误能量之源呐
    var errorProvider : PublishSubject<RxMGError> { get set }
    
    /// 返回纯洁的能量，当错误时候把能量会给到errorProvider
    ///
    /// - Parameters:
    ///   - requestSignal: Wings层来的请求
    ///   - key: 错误标识
    /// - Returns: 你想要的请求
    func requestAfterErrorFilterd<Element>(withResultSignal requestSignal : Observable<Result<Element,MGAPIError>> , withFlag key : String?) -> Observable<Element>
}

// 处理错误的方法
public extension NeedHandleRequestError where Self : HaveRequestRx
{
    func requestAfterErrorFilterd<Element>(withResultSignal
        requestSignal : Observable<Result<Element,MGAPIError>> ,
                                  withFlag key : String? = nil) -> Observable<Element>
    {
        let filteredResult = trackRequest(signal: requestSignal).trackActivity(self.loadingActivity).do(onNext: {[weak self]result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .failure(let error):
                
                strongSelf.errorProvider.onNext(RxMGError(identifier: key, apiError: error))

            default:
                break
            }
        })
        
        return pureRequest(withResultSignal: filteredResult)
    }
}






