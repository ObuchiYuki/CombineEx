//
//  Property.swift
//  CoreUtil
//
//  Created by yuki on 2020/07/06.
//  Copyright © 2020 yuki. All rights reserved.
//

import Combine

@propertyWrapper
public struct ObservableProperty<Value> {
    
    @inlinable public var projectedValue: some Publisher<Value, Never> {
        self.subject
    }

    @usableFromInline let subject: CurrentValueSubject<Value, Never>
    
    @inlinable public var wrappedValue: Value {
        @inlinable get { self.subject.value }
        @inlinable set { self.subject.send(newValue) }
    }
    
    @inlinable public init(wrappedValue value: Value) {
        self.subject = CurrentValueSubject(value)
    }
}
