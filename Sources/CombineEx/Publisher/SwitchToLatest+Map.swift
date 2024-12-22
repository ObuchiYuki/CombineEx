//
//  SwitchToLatest.swift
//  CoreUtil
//
//  Created by yuki on 2021/01/25.
//  Copyright © 2021 yuki. All rights reserved.
//

import Combine

extension Publisher {
    @inlinable public func switchToLatest<P, Q>(
        _ tranceform: @escaping (Output) -> P
    ) -> some Publisher<P.Output, P.Failure>
        where P: Publisher, P.Output == Q, P.Failure == Failure
    {
        map(tranceform).switchToLatest()
    }
}

