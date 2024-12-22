//
//  NSObject+Combine.swift
//  CoreUtil
//
//  Created by yuki on 2020/05/22.
//  Copyright © 2020 yuki. All rights reserved.
//

import Foundation
import Combine

@usableFromInline var cancellableKey = 0 as UInt8

extension NSObject {
    final public class Cancellables: RangeReplaceableCollection {
        public typealias Index = Array<AnyCancellable>.Index

        public typealias Element = Array<AnyCancellable>.Element
        
        @usableFromInline var storage = [AnyCancellable]()
        
        @inlinable public init() {}

        @inlinable public var startIndex: Index { self.storage.startIndex }
        
        @inlinable public var endIndex: Index { self.storage.endIndex }
        
        @inlinable public subscript(position: Index) -> Element {
            @inlinable get { self.storage[position] }
            @inlinable set { self.storage[position] = newValue }
        }
        
        @inlinable public func index(after i: Index) -> Index {
            self.storage.index(after: i)
        }
        
        @inlinable public func makeIterator() -> IndexingIterator<[AnyCancellable]> {
            self.storage.makeIterator()
        }
        
        @inlinable public func replaceSubrange<C: Collection>(_ subrange: Range<Int>, with newElements: C) where C.Element == AnyCancellable {
            self.storage.replaceSubrange(subrange, with: newElements)
        }
        
        @inlinable public func append(_ newElement: Array<AnyCancellable>.Element) {
            self.storage.append(newElement)
        }
        
        @inlinable public func removeAll() {
            self.storage.removeAll()
        }
    }
    
    /// Set<AnyCancellable>を公開してしまうと、更新が常にO(N)になるため、Classにしてある。
    @available(*, deprecated, message: "Use cancellables instead")
    @inlinable public var objectBag: Cancellables {
        @inlinable get { self.cancellableContainer.value }
        @inlinable set { self.cancellableContainer.value = newValue }
    }
    
    @inlinable public var cancellables: Cancellables {
        @inlinable get { self.cancellableContainer.value }
        @inlinable set { self.cancellableContainer.value = newValue }
    }
    
    @usableFromInline final class CancellableContainer {
        @usableFromInline var value = Cancellables()
        
        @inlinable init() {}
    }
    
    @inlinable var cancellableContainer: CancellableContainer {
        if let container = objc_getAssociatedObject(self, &cancellableKey) as? CancellableContainer { return container }
        let container = CancellableContainer()
        objc_setAssociatedObject(self, &cancellableKey, container, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return container
    }
}
