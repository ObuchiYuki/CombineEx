//
//  AnyValue.swift
//  CombineEx
//
//  Created by yuki on 2024/12/26.
//

import Combine

final public class AnyValue<Output>: Value {
    @usableFromInline let base: any Value<Output>
    
    @inlinable public init(_ base: any Value<Output>) {
        self.base = base
    }
    
    public var value: Output {
        self.base.value
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        self.base.receive(subscriber: subscriber)
    }
}

extension Value {
    @inlinable public func eraseToAnyValue() -> AnyValue<Output> {
        AnyValue(self)
    }
}
