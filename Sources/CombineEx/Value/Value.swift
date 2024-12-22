//
//  Value.swift
//  CombineEx
//
//  Created by yuki on 2024/12/22.
//

import Combine

public protocol Value<Output>: Publisher where Failure == Never {
    var value: Output { get }
}
