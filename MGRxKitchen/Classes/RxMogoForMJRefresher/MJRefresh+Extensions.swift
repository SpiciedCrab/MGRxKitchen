//
//  MJRefresh+Extensions.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/12/4.
//

import MJRefresh

public struct MGPullConstraints {
    
    public static var pullingDuration: TimeInterval = 0.5
    public static var refreshingDuration: TimeInterval = 0.3
    public static var willRefreshDuration: TimeInterval = 0.5
    public static var idleDuration: TimeInterval = 0.5
    
}

protocol MGGifImageRefresher {
    func setImages(_ images: [Any]!, duration: TimeInterval, for state: MJRefreshState)
}

extension MGGifImageRefresher {
    func setupRefresher(with images: [UIImage]) {
        if images.count > 1 {
            setImages(images, duration: MGPullConstraints.pullingDuration, for: .pulling)
            setImages(images, duration: MGPullConstraints.refreshingDuration, for: .refreshing)
            setImages(images, duration: MGPullConstraints.willRefreshDuration, for: .willRefresh)
            setImages(images, duration: MGPullConstraints.idleDuration, for: .idle)
        }
    }
}

extension MJRefreshGifHeader: MGGifImageRefresher {
}

extension MJRefreshBackGifFooter: MGGifImageRefresher {
}
