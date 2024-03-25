//
//  File.swift
//  
//
//  Created by yuki on 2023/12/15.
//

import Combine

extension Publisher {
    @inlinable public func peek(_ block: @escaping (Output) -> Void) -> Publishers.Map<Self, Output> {
        self.map { block($0); return $0 }
    }
    
    @inlinable public func peekError(_ block: @escaping (Failure) -> Void) -> Publishers.MapError<Self, Failure> {
        self.mapError { f -> Failure in block(f); return f }
    }
}

