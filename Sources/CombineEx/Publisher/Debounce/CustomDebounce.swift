//
//  GroupByEvent.swift
//  CoreUtil
//
//  Created by yuki on 2021/09/25.
//  Copyright © 2021 yuki. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    @inlinable public func debounce<Debounce: DebouncerProtocol>(by debounce: Debounce) -> Publishers.CustomDebounce<Self, Debounce> {
        Publishers.CustomDebounce(upstream: self, debounce: debounce)
    }
}

extension Publishers {
    public struct CustomDebounce<Upstream: Publisher, Debounce: DebouncerProtocol>: Publisher {
        public typealias Output = Upstream.Output
        public typealias Failure = Upstream.Failure
        
        public let debounce: Debounce
        public let upstream: Upstream
        
        @inlinable public init(upstream: Upstream, debounce: Debounce) {
            self.upstream = upstream
            self.debounce = debounce
        }
        
        @inlinable public func receive<Downstream : Subscriber>(subscriber downstream: Downstream)
            where Self.Failure == Downstream.Failure, Self.Output == Downstream.Input
        {
            self.upstream.subscribe(Inner(downstream: downstream, debounce: self.debounce))
        }
    }
}

extension Publishers.CustomDebounce {
    final public class Inner<Downstream: Subscriber>: Subscriber where Downstream.Input == Output, Downstream.Failure == Upstream.Failure {
        public typealias Input = Upstream.Output
        public typealias Failure = Upstream.Failure
        
        public let downstream: Downstream
        public let debounce: Debounce
        
        @inlinable init(downstream: Downstream, debounce: Debounce) {
            self.downstream = downstream
            self.debounce = debounce
        }

        @inlinable public func receive(subscription: Subscription) {
            self.downstream.receive(subscription: subscription)
        }

        @inlinable public func receive(_ input: Input) -> Subscribers.Demand {
            self.debounce { _ = self.downstream.receive(input) }
            
            return .max(0)
        }

        @inlinable public func receive(completion: Subscribers.Completion<Failure>) {
            self.downstream.receive(completion: completion)
        }
    }
}
