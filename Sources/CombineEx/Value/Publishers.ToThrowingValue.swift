//
//  File.swift
//  CombineEx
//
//  Created by yuki on 2024/12/22.
//

import Combine

extension Value {
    @inlinable public func toThrowingValue() -> Publishers.ToThrowingValue<Self> {
        Publishers.ToThrowingValue(upstream: self)
    }
}

extension Publishers {
    public final class ToThrowingValue<Upstream: Value>: ThrowingValue {
        
        public typealias Output = Upstream.Output
        public typealias Failure = Never
        
        @usableFromInline let upstream: Upstream
        
        @inlinable public init(upstream: Upstream) {
            self.upstream = upstream
        }
        
        @inlinable public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
            self.upstream.receive(subscriber: subscriber)
        }
        
        @inlinable public var value: Upstream.Output {
            self.upstream.value
        }
    }
}

