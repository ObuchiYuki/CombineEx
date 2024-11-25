//
//  CombineLatestBuilder.swift
//  CombineLatest
//
//  Created by yuki on 2024/11/25.
//

import Combine

@resultBuilder
public struct CombineLatestBuilder {
    @inlinable
    public init() {}
    
    @inlinable
    public static func buildBlock<P0: Publisher>(_ p0: P0) -> some Publisher<P0.Output, P0.Failure> {
        return p0
    }

    @inlinable
    public static func buildBlock<P0: Publisher, P1: Publisher>(_ p0: P0, _ p1: P1) -> some Publisher<(P0.Output, P1.Output), P0.Failure> where P0.Failure == P1.Failure {
        return p0.combineLatest(p1)
    }

    @inlinable
    public static func buildBlock<P0: Publisher, P1: Publisher, P2: Publisher>(_ p0: P0, _ p1: P1, _ p2: P2) -> some Publisher<(P0.Output, P1.Output, P2.Output), P0.Failure> where P0.Failure == P1.Failure, P1.Failure == P2.Failure {
        return Publishers.CombineLatest3(p0, p1, p2)
    }

    @inlinable
    public static func buildBlock<P0: Publisher, P1: Publisher, P2: Publisher, P3: Publisher>(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) -> some Publisher<(P0.Output, P1.Output, P2.Output, P3.Output), P0.Failure> where P0.Failure == P1.Failure, P1.Failure == P2.Failure, P2.Failure == P3.Failure {
        return Publishers.CombineLatest4(p0, p1, p2, p3)
    }

    @inlinable
    public static func buildBlock<P0: Publisher, P1: Publisher, P2: Publisher, P3: Publisher, P4: Publisher>(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) -> some Publisher<(P0.Output, P1.Output, P2.Output, P3.Output, P4.Output), P0.Failure> where P0.Failure == P1.Failure, P1.Failure == P2.Failure, P2.Failure == P3.Failure, P3.Failure == P4.Failure {
        let combinedFirstFour = Publishers.CombineLatest4(p0, p1, p2, p3)
        return combinedFirstFour
            .combineLatest(p4)
            .map { (firstFourOutputs, p4Output) in
                return (firstFourOutputs.0, firstFourOutputs.1, firstFourOutputs.2, firstFourOutputs.3, p4Output)
            }
    }

    @inlinable
    public static func buildBlock<
        P0: Publisher, P1: Publisher, P2: Publisher, P3: Publisher, P4: Publisher,
        P5: Publisher
    >(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) -> some Publisher<(P0.Output, P1.Output, P2.Output, P3.Output, P4.Output, P5.Output), P0.Failure> where
        P0.Failure == P1.Failure, P1.Failure == P2.Failure, P2.Failure == P3.Failure,
        P3.Failure == P4.Failure, P4.Failure == P5.Failure
    {
        let combinedFirstFour = Publishers.CombineLatest4(p0, p1, p2, p3)
        let combinedLastTwo = p4.combineLatest(p5)
        return combinedFirstFour
            .combineLatest(combinedLastTwo)
            .map { (firstFourOutputs, lastTwoOutputs) in
                return (firstFourOutputs.0, firstFourOutputs.1, firstFourOutputs.2, firstFourOutputs.3, lastTwoOutputs.0, lastTwoOutputs.1)
            }
    }

    @inlinable
    public static func buildBlock<
        P0: Publisher, P1: Publisher, P2: Publisher, P3: Publisher, P4: Publisher,
        P5: Publisher, P6: Publisher
    >(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) -> some Publisher<(P0.Output, P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output), P0.Failure> where
        P0.Failure == P1.Failure, P1.Failure == P2.Failure, P2.Failure == P3.Failure,
        P3.Failure == P4.Failure, P4.Failure == P5.Failure, P5.Failure == P6.Failure
    {
        let combinedFirstFour = Publishers.CombineLatest4(p0, p1, p2, p3)
        let combinedLastThree = Publishers.CombineLatest3(p4, p5, p6)
        return combinedFirstFour
            .combineLatest(combinedLastThree)
            .map { (firstFourOutputs, lastThreeOutputs) in
                return (
                    firstFourOutputs.0, firstFourOutputs.1, firstFourOutputs.2, firstFourOutputs.3,
                    lastThreeOutputs.0, lastThreeOutputs.1, lastThreeOutputs.2
                )
            }
    }

    @inlinable
    public static func buildBlock<
        P0: Publisher, P1: Publisher, P2: Publisher, P3: Publisher,
        P4: Publisher, P5: Publisher, P6: Publisher, P7: Publisher,
        P8: Publisher, P9: Publisher
    >(
        _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3,
        _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7,
        _ p8: P8, _ p9: P9
    ) -> some Publisher<(P0.Output, P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output), P0.Failure> where
        P0.Failure == P1.Failure, P1.Failure == P2.Failure,
        P2.Failure == P3.Failure, P3.Failure == P4.Failure,
        P4.Failure == P5.Failure, P5.Failure == P6.Failure,
        P6.Failure == P7.Failure, P7.Failure == P8.Failure,
        P8.Failure == P9.Failure
    {
        let combinedFirstFour = Publishers.CombineLatest4(p0, p1, p2, p3)
        let combinedSecondFour = Publishers.CombineLatest4(p4, p5, p6, p7)
        let combinedFirstEight = combinedFirstFour.combineLatest(combinedSecondFour)
            .map { (firstFourOutputs, secondFourOutputs) in
                (
                    firstFourOutputs.0, firstFourOutputs.1, firstFourOutputs.2, firstFourOutputs.3,
                    secondFourOutputs.0, secondFourOutputs.1, secondFourOutputs.2, secondFourOutputs.3
                )
            }
        return combinedFirstEight
            .combineLatest(p8, p9)
            .map { (firstEightOutputs, p8Output, p9Output) in
                (
                    firstEightOutputs.0, firstEightOutputs.1, firstEightOutputs.2, firstEightOutputs.3,
                    firstEightOutputs.4, firstEightOutputs.5, firstEightOutputs.6, firstEightOutputs.7,
                    p8Output, p9Output
                )
            }
    }
}
