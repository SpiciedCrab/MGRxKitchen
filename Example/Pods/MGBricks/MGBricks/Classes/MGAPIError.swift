//
//  MogoAPIError.swift
//  Pods
//
//  Created by luhao on 2017/8/21.
//
//

import Foundation

public struct MGAPIError: Error {
    
    public var message: String?
    public var code: String?
    public var object: Any?
    
    public init(_ code: String?, message: String?) {
        self.code = code
        self.message = message
    }
}

