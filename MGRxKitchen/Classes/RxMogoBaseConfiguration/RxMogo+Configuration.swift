//
//  RxMogo+Configuration.swift
//  MGRxKitchen
//
//  Created by Harly on 2017/11/10.
//

import Foundation

public class MGRxKichenConfiguration {

    public static let shared: MGRxKichenConfiguration = MGRxKichenConfiguration()

    public var emptyImage: UIImage?
    
    public var mjLoadingImages: [UIImage]?

    /// 配置一个空态页啦
    ///
    /// - Parameter image: image
    public func config(emptyImage image: UIImage?, mjLoadings: [UIImage]? = nil) {
        emptyImage = image
        mjLoadingImages = mjLoadings
    }
}
