//
//  CombineLatestCollection.swift
//  CoreUtil
//
//  Created by yuki on 2020/06/13.
//  Copyright © 2020 yuki. All rights reserved.
//

import Foundation
import Combine

extension Collection where Element: Publisher {
    @inlinable public var combineLatest: Publishers.CombineLatestCollection<Self> {
        Publishers.CombineLatestCollection(upstreams: self)
    }
}

extension Publishers {
    public struct CombineLatestCollection<Upstreams: Collection>: Publisher where Upstreams.Element: Combine.Publisher {
        public typealias Output = Array<Upstreams.Element.Output>
        public typealias Failure = Upstreams.Element.Failure
        
        public enum Publisher {
            case publishers(Upstreams)
            case empty(Just<Output>)
        }
        
        public let publisher: Publisher

        @inlinable public init(upstreams: Upstreams) {
            if upstreams.isEmpty {
                self.publisher = .empty(Just([]))
            } else {
                self.publisher = .publishers(upstreams)
            }
        }

        @inlinable public func receive<Downstream: Subscriber>(subscriber downstream: Downstream)
            where Downstream.Input == Output, Downstream.Failure == Self.Failure
        {
            switch self.publisher {
            case .empty(let just):
                just.convertToFailure().receive(subscriber: downstream)
            case .publishers(let publishers):
                let inner = Inner<Downstream>(downstream: downstream, upstreamCount: publishers.count)
                publishers.enumerated().forEach{ i, upstream in upstream.map{ (i, $0) }.subscribe(inner) }
            }
        }
    }
}

extension Publishers.CombineLatestCollection: Value where Upstreams.Element: Value {
    public var value: Output {
        switch self.publisher {
        case .empty(let just):
            return just.value
        case .publishers(let publishers):
            return publishers.map{ $0.value }
        }
    }
}

extension Publishers.CombineLatestCollection: ThrowingValue where Upstreams.Element: ThrowingValue {
    public var value: Output {
        get throws {
            switch self.publisher {
            case .empty(let just):
                return just.value
            case .publishers(let publishers):
                return try publishers.map{ try $0.value }
            }
        }
    }
}

extension Publishers.CombineLatestCollection {
    public final class Inner<Downstream: Combine.Subscriber>: Combine.Subscriber
        where Downstream.Input == Array<Upstreams.Element.Output>
    {
        public typealias Input = (index: Int, value: Upstreams.Element.Output)
        public typealias Failure = Downstream.Failure
        
        @usableFromInline let downstream: Downstream
        
        @usableFromInline let upstreamCount: Int
        
        @usableFromInline let subscription = Subscription()
        
        @usableFromInline var valueReceivedCount = 0
        
        /// 全ての値を受け取るまでのstorage
        /// 毎回unwrapをするのは重いので全ての値を受け取るまでは`prebuildStorage`、全ての値を受け取った後は`valueStorage`で管理している。
        @usableFromInline var prebuildStorage: Array<Upstreams.Element.Output?>
        /// 全ての値を受け取った後のstorage
        @usableFromInline var valueStorage: Array<Upstreams.Element.Output> = []
        
        /// すでに全ての値を受け取ったかどうか
        @usableFromInline var receivedAllValues = false
        /// 完了しているかどうか（`failure`を受け取った or 全てのupstreamがfinishedした）
        @usableFromInline var isCompleted = false
        /// 受け取ったfinishedのCount
        @usableFromInline var finishedCount: Int = 0
                
        @inlinable init(downstream: Downstream, upstreamCount: Int) {
            self.downstream = downstream
            self.upstreamCount = upstreamCount
            
            self.prebuildStorage = .init(repeating: nil, count: upstreamCount)
        }
        
        @inlinable public func receive(subscription: Combine.Subscription) {
            self.subscription.subscriptions.append(subscription)
            guard self.subscription.subscriptions.count == upstreamCount else { return }
            self.downstream.receive(subscription: self.subscription)
        }
        
        @inlinable public func receive(_ input: (index: Int, value: Upstreams.Element.Output)) -> Subscribers.Demand {
            if self.receivedAllValues {
                self.valueStorage[input.index] = input.value
                
                return self.downstream.receive(self.valueStorage)
            } else {
                self.prebuildStorage[input.index] = input.value
                
                guard self.prebuildStorage[input.index] == nil else { return .max(1) }
                
                self.valueReceivedCount += 1
                
                if self.valueReceivedCount == self.upstreamCount {
                    self.receivedAllValues = true
                    self.valueStorage = self.prebuildStorage.map{ $0! }
                    self.prebuildStorage.removeAll()
                    return self.downstream.receive(self.valueStorage)
                }
            }
            
            return .max(1)
        }
        
        @inlinable public func receive(completion: Subscribers.Completion<Downstream.Failure>) {
            guard !self.isCompleted else { return }
            
            switch completion {
            case .failure(let error):
                self.isCompleted = true
                self.downstream.receive(completion: .failure(error))
            case .finished:
                self.finishedCount += 1
                
                if self.finishedCount == self.upstreamCount {
                    self.isCompleted = true
                    self.downstream.receive(completion: .finished)
                }
            }
        }
    }
    
    final public class Subscription: Combine.Subscription {
        @usableFromInline var subscriptions = [Combine.Subscription]()
        
        public func request(_ demand: Subscribers.Demand) {
            for subscription in subscriptions {
                subscription.request(demand)
            }
        }
        
        public func cancel() {
            for subscription in subscriptions {
                subscription.cancel()
            }
        }
    }
}

extension Publisher {
    public func convertToFailure<T: Error>() -> Publishers.MapError<Self, T> {
        self.mapError{_ in fatalError() }
    }
}

