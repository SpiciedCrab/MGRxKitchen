//
//  Version.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 5/20/17.
//  Copyright © 2017 Krunoslav Zaher. All rights reserved.
//

import class Foundation.NSObject

public class Unique: NSObject {
}

public struct Version<Value>: Hashable {

    private let _unique: Unique
    public let value: Value

    public init(_ value: Value) {
        self._unique = Unique()
        self.value = value
    }

    public var hashValue: Int {
        return self._unique.hash
    }

    public static func == (lhs: Version<Value>, rhs: Version<Value>) -> Bool {
        return lhs._unique === rhs._unique
    }
}
extension Version {
    public func mutate(transform: (inout Value) -> ()) -> Version<Value> {
        var newSelf = self.value
        transform(&newSelf)
        return Version(newSelf)
    }

    public func mutate(transform: (inout Value) throws -> ()) rethrows -> Version<Value> {
        var newSelf = self.value
        try transform(&newSelf)
        return Version(newSelf)
    }
}
