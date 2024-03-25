//
//  File.swift
//  
//
//  Created by yuki on 2024/01/09.
//

import Combine

// Combine.Schedulerと同じと思えばここにあっていい。

public protocol DebouncerProtocol {
    func execute(_ body: @escaping () -> ())
}

extension DebouncerProtocol {
    @inlinable public func callAsFunction(_ body: @escaping () -> ()) {
        self.execute(body)
    }
}

