//
//  MockService.swift
//  RxMogo
//
//  Created by Harly on 2017/8/7.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Result
import MGBricks

//MARK : - Demo api
class Demo
{
    var name : String = ""
    
    static func buildDemos(on page : Int) -> [Demo]
    {
        var demos = [Demo]()
        
        for i in 1..<10
        {
            let demo = Demo()
            demo.name = "page_\(page) : data__ \(i)"
            demos.append(demo)
        }
        
        return demos
    }
}

//MARK : - Demo service
class MockService: NSObject
{
    func provideMock(on page : Int) -> Observable<Result<[Demo] , MGAPIError>>
    {
        return Observable<Result<[Demo], MGAPIError>>.create({ (observer) -> Disposable in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//                observer.onNext(Result.error(MGAPIError(object: ["message" : "error lalala"])))
                
                observer.onNext(Result.init(value: Demo.buildDemos(on: 0)))
                observer.onCompleted()
            })

            return Disposables.create {
                
            }
        })
    }
}
