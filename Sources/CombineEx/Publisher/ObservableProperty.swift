//
//  Property.swift
//  CoreUtil
//
//  Created by yuki on 2020/07/06.
//  Copyright © 2020 yuki. All rights reserved.
//

import Combine

@propertyWrapper
public struct ObservableProperty<Output> {
    
    @inlinable public var projectedValue: some Value<Output> {
        self.subject
    }

    @usableFromInline let subject: CurrentValueSubject<Output, Never>
    
    @inlinable public var wrappedValue: Output {
        @inlinable get { self.subject.value }
        @inlinable set { self.subject.send(newValue) }
    }
    
    @inlinable public init(wrappedValue value: Output) {
        self.subject = CurrentValueSubject(value)
    }
}
