//
//  FilterByPublisher.swift
//  CoreUtil
//
//  Created by yuki on 2021/11/11.
//  Copyright © 2021 yuki. All rights reserved.
//

import Combine

extension Publisher {
    /// Publisherにtrueが流れている時のみ値を流すPublisherを返す。
    ///
    /// - Parameter publisher: true/falseを流すPublisher
    @inlinable public func filter<P: Combine.Publisher>(by publisher: P) -> some Publisher<Self.Output, Self.Failure>
        where P.Output == Bool, P.Failure == Self.Failure
    {
        self.combineLatest(publisher).filter{ _, flag in flag }.map{ $0.0 }
    }
}
