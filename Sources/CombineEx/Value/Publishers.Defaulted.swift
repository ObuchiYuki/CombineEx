//
//  DefaultValue.swift
//  ValuePubilsher
//
//  Created by yuki on 2024/12/21.
//

import Combine

extension Publisher {
    @inlinable public func defaulting(to defaultValue: Output) -> Publishers.Defaulted<Self> where Self.Failure == Never {
        Publishers.Defaulted(upstream: self, defaultValue: defaultValue)
    }
    
    @inlinable public func defaulting(to defaultValue: Output) -> Publishers.ThrowingDefaulted<Self> {
        Publishers.ThrowingDefaulted(upstream: self, defaultValue: defaultValue)
    }
}

extension Publishers {
    public final class Defaulted<Upstream: Publisher>: Value where Upstream.Failure == Never {
        
        public typealias Output = Upstream.Output
        public typealias Failure = Never
        
        @usableFromInline let subject: CurrentValueSubject<Output, Never>
        
        @usableFromInline var cancellable: AnyCancellable?
        
        @inlinable public init(upstream: Upstream, defaultValue: Output) {
            self.subject = CurrentValueSubject(defaultValue)
            
            self.cancellable = upstream.sink(
                receiveCompletion: { _ in
                    // 完了後も subject には最後に送られた値が残るので特に何もしない
                },
                receiveValue: { [unowned self] in
                    self.subject.send($0)
                }
            )
        }
        
        @inlinable public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
            self.subject.receive(subscriber: subscriber)
        }
        
        @inlinable public var value: Output { self.subject.value }
    }
    
    public final class ThrowingDefaulted<Upstream: Publisher>: ThrowingValue {
        
        public typealias Output = Upstream.Output
        public typealias Failure = Never
        
        @usableFromInline let subject: CurrentValueSubject<Output, Never>
        
        @usableFromInline var cancellable: AnyCancellable?
        
        @usableFromInline var error: Upstream.Failure?
        
        @inlinable public init(upstream: Upstream, defaultValue: Output) {
            self.subject = CurrentValueSubject(defaultValue)
            
            self.cancellable = upstream.sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.error = error
                    }
                },
                receiveValue: { [unowned self] in
                    self.subject.send($0)
                }
            )
        }
        
        @inlinable public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
            self.subject.receive(subscriber: subscriber)
        }
        
        @inlinable public var value: Output {
            get throws {
                if let error = self.error { throw error }
                return self.subject.value
            }
        }
    }
}

