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
        
        print("hellolllll")
        
        for i in 1..<10
        {
            let demo = Demo()
            demo.name = "page_\(page) : data__ \(i)"
            demos.append(demo)
        }
        
        return demos
    }
    
    static func buildPage(on page : Int) -> MGPage
    {
        let pageInfo =  MGPage()
        pageInfo.currentPage = page
        pageInfo.totalPage = 10
        return pageInfo
    }
}

//MARK : - Demo service
class MockService: NSObject
{
    func provideMock(on page : Int) -> Observable<Result<([Demo] , MGPage), MGAPIError>>
    {
        return Observable<Result<([Demo],MGPage), MGAPIError>>.create({ (observer) -> Disposable in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//                observer.onNext(Result.init(error: MGAPIError(object: ["message" : "error lalala"])))
                print("request : \(page) times")
                observer.onNext(Result.init(value: (Demo.buildDemos(on: page) , Demo.buildPage(on: page))))
                observer.onCompleted()
            })

            return Disposables.create {
                
            }
        })
    }
}
