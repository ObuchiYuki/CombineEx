//
//  File.swift
//  CombineEx
//
//  Created by yuki on 2024/12/22.
//

import Combine

public protocol ThrowingValue<Output>: Publisher {
    var value: Output { get throws }
}
