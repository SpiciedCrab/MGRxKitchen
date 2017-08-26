//
//  MogoAPIError.swift
//  Pods
//
//  Created by luhao on 2017/8/21.
//
//

import Foundation

public struct MGAPIError: Error {
    
    public let message: String
    public var code: Int
    
    public init(object: Any) {
        let dictionary = object as? [String: Any]
        
        code = 99999
        if let statusStr = dictionary?["resultCode"] as? String,
            let statusCode = Int(statusStr) {
            code = statusCode
        }
        
        message = dictionary?["resultMsg"] as? String ?? "Unknown error occurred"
    }
}

