//
//  Publishers+Sink.swift
//  CoreUtil
//
//  Created by yuki on 2020/10/03.
//  Copyright © 2020 yuki. All rights reserved.
//

import Combine

extension Optional where Wrapped: Combine.Publisher, Wrapped.Failure == Never {
    @inlinable public func unwrap(_ defaultValue: Wrapped.Output) -> AnyPublisher<Wrapped.Output, Never> {
        self?.eraseToAnyPublisher() ?? Just(defaultValue).eraseToAnyPublisher()
    }
}
