//
//  File.swift
//  
//
//  Created by yuki on 2023/12/15.
//

import Combine

extension Publisher where Failure == Never {
    @inlinable public func takeValue() -> Output? {
        var value: Output? = nil
        _ = self.sink{ value = $0 }
        return value
    }
    
    @inlinable public func takeOptionalValue<T>() -> Self.Output where Self.Output == Optional<T> {
        var value: Self.Output = nil
        _ = self.sink{ value = $0 }
        return value
    }
}

