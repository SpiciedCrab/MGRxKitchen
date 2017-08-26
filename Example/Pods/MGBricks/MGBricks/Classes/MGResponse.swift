//
//  MGResponse.swift
//  Pods
//
//  Created by luhao on 2017/8/25.
//
//

import Foundation

public struct MGResponse {
    
    public var urlResponse: URLResponse?
    public var rawData: [String : Any] = [:]
    public var code: Int = 0
    public var message: String = ""
    public var detail: String = ""
    public var content: [String : Any] = [:]
    public var page: MGPage? = nil
    
    public init() {}
}
