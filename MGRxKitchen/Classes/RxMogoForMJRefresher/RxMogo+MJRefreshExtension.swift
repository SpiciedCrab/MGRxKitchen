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

// MARK: - Reactive to Handle pull refreshes
extension Reactive where Base : UIScrollView {
    /// PullDown request Driver
    public var pullDownRefreshing: ControlEvent<Void> {
        let pullDownDriver = PublishSubject<Void>()
        if base.mj_header == nil {

            base.mj_header = headerRefresher {
                pullDownDriver.onNext(())
            }
        }

        let event = ControlEvent(events: pullDownDriver)

        return event
    }

    /// PullUp request Driver
    public var pullUpRefreshing: ControlEvent<Void> {
        let pullUpDriver = PublishSubject<Void>()
        if base.mj_footer == nil {

            base.mj_footer = footRefresher {
                pullUpDriver.onNext(())
            }
        }

        let event = ControlEvent(events: pullUpDriver)

        return event
    }

    /// 上拉能量终点
    public var makMePullDown: UIBindingObserver<Base, Void> {

        return UIBindingObserver(UIElement: self.base, binding: { tableView, _ in
            guard let header = tableView.mj_header else {
                return
            }

            header.beginRefreshing()
        })
    }

    /// 下拉能量终点
    public var makMePullUp: UIBindingObserver<Base, Void> {

        return UIBindingObserver(UIElement: self.base, binding: { tableView, _ in
            guard let footer = tableView.mj_footer else {
                return
            }

            footer.beginRefreshing()
        })
    }

    /// 到达最后一页
    public var makTouchLastPage: UIBindingObserver<Base, Void> {

        return UIBindingObserver(UIElement: self.base, binding: { tableView, _ in
            guard let footer = tableView.mj_footer else {
                return
            }

            footer.endRefreshingWithNoMoreData()
        })
    }

    /// 全部停止刷新节点
    public var makMeStopRefreshing: UIBindingObserver<Base, Bool> {

        return UIBindingObserver(UIElement: self.base, binding: { tableView, isLoading in

            guard !isLoading else { return }

            if let footer = tableView.mj_footer , footer.isRefreshing {
                footer.endRefreshing()
            }

            if let header = tableView.mj_header , header.isRefreshing {
                header.endRefreshing()
            }
        })
    }
    
    fileprivate func headerRefresher(with refreshBlock : @escaping ()->())
        -> MJRefreshStateHeader?
    {
        if let headerImages = MGRxKichenConfiguration.shared.mjLoadingImages
        {
            let header = MJRefreshGifHeader(refreshingBlock: {
                refreshBlock()
            })
            
            header?.setupRefresher(with: headerImages)
            
            header?.lastUpdatedTimeLabel.isHidden = true
            header?.lastUpdatedTimeLabel.isHidden = true
            header?.stateLabel.isHidden = true
            
            return header
        }
        
        let header = MJRefreshNormalHeader(refreshingBlock: {
            refreshBlock()
        })
        
        return header
    }
    
    fileprivate func footRefresher(with refreshBlock : @escaping ()->())
        -> MJRefreshFooter?
    {
        if let footerImages = MGRxKichenConfiguration.shared.mjLoadingImages
        {
            let footer = MJRefreshBackGifFooter(refreshingBlock: {
                refreshBlock()
            })
            
            footer?.setupRefresher(with: footerImages)
            
            footer?.stateLabel.isHidden = true
            
            return footer
        }
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: {
            refreshBlock()
        })
        
        return footer
    }
}
