//
//  CompactSwitchToLatest.swift
//  CoreUtil
//
//  Created by yuki on 2021/11/19.
//  Copyright © 2021 yuki. All rights reserved.
//

import Combine

extension Publisher where Failure == Never {
    /// If the publisher that flows through the optional publisher is nil, the output is nil.
    ///
    ///     let publisher = PassThroughSubject<CurrentValueSubject<Int, Never>?, Never>()
    ///
    ///     pubilsher.compactSwitchToLatest()
    ///         .sink { print($0) }
    ///         .store(in: &cancellables)
    ///
    ///     publisher.send(nil) // nil
    ///     let subject = CurrentValueSubject<Int, Never>(1)
    ///     publisher.send(subject) // 1
    ///     subject.send(2) // 2
    ///
    ///     - Returns: A publisher that publishes the latest value from the latest publisher.
    @inlinable public func involveSwitchToLatest<T: Publisher>() -> some Publisher<T.Output?, Never>
        where Self.Output == Optional<T>, T.Failure == Never
    {
        self
            .map{
                $0?.map{
                    Optional.some($0)
                }.eraseToAnyPublisher() ?? Just(nil).eraseToAnyPublisher()
            }
            .switchToLatest()
    }
}

