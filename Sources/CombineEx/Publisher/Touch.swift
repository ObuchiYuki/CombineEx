//
//  Touch.swift
//  CoreUtil
//
//  Created by yuki on 2021/11/04.
//  Copyright © 2021 yuki. All rights reserved.
//

import Combine

extension Publisher {
    /// When the argument publisher flows, the current value is flowed.
    ///
    ///     let publisher = PassthroughSubject<Int, Never>()
    ///     let subject = CurrentValueSubject<Int, Never>(1)
    ///     
    ///     publisher.touch(subject)
    ///         .sink { print($0) }
    ///         .store(in: &cancellables)
    ///
    ///     publisher.send(2) // 1
    ///     subject.send(3) // 3
    ///
    ///
    /// - Parameter toucher: The publisher to touch.
    ///
    /// - Returns: A publisher that publishes the latest value from the latest publisher.
    @inlinable public func touch<P: Publisher>(_ toucher: P) -> some Publisher<Output, Failure>
        where P.Failure == Failure
    {
        self.combineLatest(toucher).map{ $0.0 }
    }
}
