//
//  RxMogo+MJRefreshExtension.swift
//  RxMogo
//
//  Created by Harly on 2017/8/8.
//  Copyright © 2017年 Harly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh

//MARK : - Reactive to Handle pull refreshes
public extension Reactive where Base : UITableView
{
    /// PullDown request Driver
    public var pullDownRefreshing : ControlEvent<Void>
    {
        let pullDownDriver = PublishSubject<Void>()
        if base.mj_header == nil
        {
            let header = MJRefreshNormalHeader(refreshingBlock: {

                pullDownDriver.onNext(())
//                pullUpDriver.onCompleted()
            })
            base.mj_header = header
        }
        
        let event = ControlEvent(events: pullDownDriver)

        return event
    }
    
    /// PullUp request Driver
    public var pullUpRefreshing : ControlEvent<Void>
    {
        let pullUpDriver = PublishSubject<Void>()
        if base.mj_footer == nil
        {
            let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                
                pullUpDriver.onNext(())

            })
            base.mj_footer = footer
        }
        
        let event = ControlEvent(events: pullUpDriver)
        
        return event
    }
}
