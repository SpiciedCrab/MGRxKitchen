//
//  RxMogo+LoadingRefresher.swift
//  RxMogo
//
//  Created by Harly on 2017/8/17.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


//MARK : - Extension For PublishSubject to display loading Views
public extension PublishSubject
{
    /// loading convertation
    ///
    /// - Parameters:
    ///   - observableDataSource: Response DataSource
    ///   - startAnimation: Start
    ///   - endAnimation: End
    /// - Returns: Response
    public func asLoadingAnimated<DataSouce>(
        mapTo observableDataSource : Observable<DataSouce> ,
        startWithAnimation  startAnimation : (()->Void)? = nil ,
        endWithAnimation  endAnimation : (()->Void)? = nil)
        -> Observable<DataSouce>
    {
        return self.do(onNext: { (_) in
            
            print("startRequest")
            
            if let realAnimation = startAnimation
            {
                realAnimation()
            }
            
        }).flatMap { _ in observableDataSource }
        .do(onNext: { (_) in
            
            print("endRequest")
            
            if let realAnimation = endAnimation
            {
                realAnimation()
            }
            
        })
        
        
    }
}
