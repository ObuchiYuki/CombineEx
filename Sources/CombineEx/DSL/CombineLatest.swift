//
//  CombineLatest.swift
//  CombineLatest
//
//  Created by yuki on 2024/11/25.
//

import Combine

public struct CombineLatest<Output, Failure: Error, Input: Publisher>: Publisher where Input.Failure == Failure, Input.Output == Output {
    public typealias Output = Output
    public typealias Failure = Failure

    @usableFromInline let publisher: Input

    @inlinable
    public init(@CombineLatestBuilder _ content: () -> Input) {
        self.publisher = content()
    }

    @inlinable
    public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}

