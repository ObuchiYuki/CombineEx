//
//  CombineLatest++.swift
//  CoreUtil
//
//  Created by yuki on 2020/09/24.
//  Copyright © 2020 yuki. All rights reserved.
//

import Combine

extension Publisher {
    // 5
    @inlinable public func combineLatest<
        Publisher1: Publisher, Publisher2: Publisher, Publisher3: Publisher, Publisher4: Publisher
    > (
        _ publisher1: Publisher1, _ publisher2: Publisher2, _ publisher3: Publisher3, _ publisher4: Publisher4
    ) -> some Publisher<(
        Self.Output,
        Publisher1.Output, Publisher2.Output, Publisher3.Output, Publisher4.Output
    ), Failure> where Self.Failure == Publisher1.Failure, Self.Failure == Publisher2.Failure, Self.Failure == Publisher3.Failure, Self.Failure == Publisher4.Failure
    {
        self.combineLatest(publisher1, publisher2, publisher3)
            .combineLatest(publisher4)
            .map { com0, com1 in
                (com0.0, com0.1, com0.2, com0.3, com1)
            }
    }

    // 6
    @inlinable public func combineLatest<
        Publisher1: Publisher, Publisher2: Publisher, Publisher3: Publisher, Publisher4: Publisher, Publisher5: Publisher
    > (
        _ publisher1: Publisher1, _ publisher2: Publisher2, _ publisher3: Publisher3, _ publisher4: Publisher4, _ publisher5: Publisher5
    ) -> some Publisher<(
        Self.Output,
        Publisher1.Output, Publisher2.Output, Publisher3.Output, Publisher4.Output, Publisher5.Output
    ), Failure> where Self.Failure == Publisher1.Failure, Self.Failure == Publisher2.Failure, Self.Failure == Publisher3.Failure, Self.Failure == Publisher4.Failure, Self.Failure == Publisher5.Failure
    {
        self.combineLatest(publisher1, publisher2, publisher3, publisher4)
            .combineLatest(publisher5)
            .map { com0, com1 in
                (com0.0, com0.1, com0.2, com0.3, com0.4, com1)
            }
    }
    
    // 7
    @inlinable public func combineLatest<
        Publisher1: Publisher, Publisher2: Publisher, Publisher3: Publisher, Publisher4: Publisher, Publisher5: Publisher, Publisher6: Publisher
    > (
        _ publisher1: Publisher1, _ publisher2: Publisher2, _ publisher3: Publisher3, _ publisher4: Publisher4, _ publisher5: Publisher5, _ publisher6: Publisher6
    ) -> some Publisher<(
        Self.Output,
        Publisher1.Output, Publisher2.Output, Publisher3.Output, Publisher4.Output, Publisher5.Output, Publisher6.Output
    ), Failure> where Self.Failure == Publisher1.Failure, Self.Failure == Publisher2.Failure, Self.Failure == Publisher3.Failure, Self.Failure == Publisher4.Failure, Self.Failure == Publisher5.Failure, Self.Failure == Publisher6.Failure
    {
        self.combineLatest(publisher1, publisher2, publisher3, publisher4, publisher5)
            .combineLatest(publisher6)
            .map { com0, com1 in
                (com0.0, com0.1, com0.2, com0.3, com0.4, com0.5, com1)
            }
    }
    
    // 8
    @inlinable public func combineLatest<
        Publisher1: Publisher, Publisher2: Publisher, Publisher3: Publisher, Publisher4: Publisher, Publisher5: Publisher, Publisher6: Publisher, Publisher7: Publisher
    > (
        _ publisher1: Publisher1, _ publisher2: Publisher2, _ publisher3: Publisher3, _ publisher4: Publisher4, _ publisher5: Publisher5, _ publisher6: Publisher6, _ publisher7: Publisher7
    ) -> some Publisher<(
        Self.Output,
        Publisher1.Output, Publisher2.Output, Publisher3.Output, Publisher4.Output, Publisher5.Output, Publisher6.Output, Publisher7.Output
    ), Failure> where Self.Failure == Publisher1.Failure, Self.Failure == Publisher2.Failure, Self.Failure == Publisher3.Failure, Self.Failure == Publisher4.Failure, Self.Failure == Publisher5.Failure, Self.Failure == Publisher6.Failure, Self.Failure == Publisher7.Failure
    {
        self.combineLatest(publisher1, publisher2, publisher3, publisher4, publisher5, publisher6)
            .combineLatest(publisher7)
            .map { com0, com1 in
                (com0.0, com0.1, com0.2, com0.3, com0.4, com0.5, com0.6, com1)
            }
    }
    
    // 9
    @inlinable public func combineLatest<
        Publisher1: Publisher, Publisher2: Publisher, Publisher3: Publisher, Publisher4: Publisher, Publisher5: Publisher, Publisher6: Publisher, Publisher7: Publisher, Publisher8: Publisher
    > (
        _ publisher1: Publisher1, _ publisher2: Publisher2, _ publisher3: Publisher3, _ publisher4: Publisher4, _ publisher5: Publisher5, _ publisher6: Publisher6, _ publisher7: Publisher7, _ publisher8: Publisher8
    ) -> some Publisher<(
        Self.Output,
        Publisher1.Output, Publisher2.Output, Publisher3.Output, Publisher4.Output, Publisher5.Output, Publisher6.Output, Publisher7.Output, Publisher8.Output
    ), Failure> where Self.Failure == Publisher1.Failure, Self.Failure == Publisher2.Failure, Self.Failure == Publisher3.Failure, Self.Failure == Publisher4.Failure, Self.Failure == Publisher5.Failure, Self.Failure == Publisher6.Failure, Self.Failure == Publisher7.Failure, Self.Failure == Publisher8.Failure
    {
        self.combineLatest(publisher1, publisher2, publisher3, publisher4, publisher5, publisher6, publisher7)
            .combineLatest(publisher8)
            .map { com0, com1 in
                (com0.0, com0.1, com0.2, com0.3, com0.4, com0.5, com0.6, com0.7, com1)
            }
    }
    
    // 10
    @inlinable public func combineLatest<
        Publisher1: Publisher, Publisher2: Publisher, Publisher3: Publisher, Publisher4: Publisher, Publisher5: Publisher, Publisher6: Publisher, Publisher7: Publisher, Publisher8: Publisher, Publisher9: Publisher
    > (
        _ publisher1: Publisher1, _ publisher2: Publisher2, _ publisher3: Publisher3, _ publisher4: Publisher4, _ publisher5: Publisher5, _ publisher6: Publisher6, _ publisher7: Publisher7, _ publisher8: Publisher8, _ publisher9: Publisher9
    ) -> some Publisher<(
        Self.Output,
        Publisher1.Output, Publisher2.Output, Publisher3.Output, Publisher4.Output, Publisher5.Output, Publisher6.Output, Publisher7.Output, Publisher8.Output, Publisher9.Output
    ), Failure> where Self.Failure == Publisher1.Failure, Self.Failure == Publisher2.Failure, Self.Failure == Publisher3.Failure, Self.Failure == Publisher4.Failure, Self.Failure == Publisher5.Failure, Self.Failure == Publisher6.Failure, Self.Failure == Publisher7.Failure, Self.Failure == Publisher8.Failure, Self.Failure == Publisher9.Failure
    {
        self.combineLatest(publisher1, publisher2, publisher3, publisher4, publisher5, publisher6, publisher7, publisher8)
            .combineLatest(publisher9)
            .map { com0, com1 in
                (com0.0, com0.1, com0.2, com0.3, com0.4, com0.5, com0.6, com0.7, com0.8, com1)
            }
    }
}
