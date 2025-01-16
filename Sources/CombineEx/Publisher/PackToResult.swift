//
//  PackToResult.swift
//  CombineEx
//
//  Created by yuki on 2025/01/16.
//

import Combine

extension Publisher {
    @inlinable public func packToResult() -> some Publisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { Just(.failure($0)) }
    }
}

extension ThrowingValue {
    @inlinable public func packToResultValue() -> some Value<Result<Output, Failure>> {
        self.map(Result.success)
            .catch { Just(.failure($0)) }
            .unsafeValue()
    }
}
