//
//  File.swift
//  CombineEx
//
//  Created by yuki on 2024/12/22.
//

import SwiftUI
import Combine

public struct PublisherView<Publisher: Value, Content: View>: View {
    public typealias Output = Publisher.Output
    
    public let publisher: Publisher
    
    public let build: (Output) -> Content
    
    @State
    @usableFromInline var value: Publisher.Output
    
    public init(_ publisher: Publisher, @ViewBuilder build: @escaping (Output) -> Content)
    {
        self.publisher = publisher
        self.build = build
        self._value = State(initialValue: publisher.value)
    }
    
    @inlinable public var body: some View {
        self.build(self.value)
            .onReceive(self.publisher) { newValue in
                self.value = newValue
            }
    }
}

