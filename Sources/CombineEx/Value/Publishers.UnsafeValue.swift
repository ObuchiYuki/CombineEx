//
//  Publishers.UnsafeValue.swift
//  ValuePubilsher
//
//  Created by yuki on 2024/12/22.
//

import Combine

extension Publisher {
    @inlinable public func unsafeValue() -> Publishers.UnsafeValue<Self> where Self.Failure == Never {
        Publishers.UnsafeValue(upstream: self)
    }
    
    @inlinable public func unsafeValue() -> Publishers.ThrowingUnsafeValue<Self> {
        Publishers.ThrowingUnsafeValue(upstream: self)
    }
}

extension Publishers {
    public final class UnsafeValue<Upstream: Publisher>: Value where Upstream.Failure == Never {
        
        public typealias Output = Upstream.Output
        public typealias Failure = Never
        
        @usableFromInline let upstream: Upstream
        
        @inlinable public init(upstream: Upstream) {
            self.upstream = upstream
        }
        
        @inlinable public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
            self.upstream.receive(subscriber: subscriber)
        }
        
        @inlinable public var value: Output {
            var value: Output!
            let cancellable = self.upstream.sink(receiveValue: { value = $0 })
            cancellable.cancel()
            return value
        }
    }
    
    public final class ThrowingUnsafeValue<Upstream: Publisher>: ThrowingValue {
        
        public typealias Output = Upstream.Output
        public typealias Failure = Upstream.Failure
        
        @usableFromInline let upstream: Upstream
        
        @inlinable public init(upstream: Upstream) {
            self.upstream = upstream
        }
        
        @inlinable public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
            self.upstream.receive(subscriber: subscriber)
        }
        
        @inlinable public var value: Output {
            get throws {
                var value: Output!
                var error: Failure?
                let cancellable = self.upstream
                    .sink(
                        receiveCompletion: { completion in
                            if case .failure(let e) = completion { error = e }
                        },
                        receiveValue: { value = $0 }
                    )
                cancellable.cancel()
                
                if let error = error { throw error }
                
                return value
            }
        }
    }
}

