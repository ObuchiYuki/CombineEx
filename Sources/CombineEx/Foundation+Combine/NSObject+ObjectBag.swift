//
//  NSObject+Combine.swift
//  CoreUtil
//
//  Created by yuki on 2020/05/22.
//  Copyright © 2020 yuki. All rights reserved.
//

import Foundation
import Combine

@usableFromInline var objectBagKey = 0 as UInt8

extension NSObject {
    final public class ObjectBag: RangeReplaceableCollection {
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
    @inlinable public var objectBag: ObjectBag {
        @inlinable get { self.bagContainer.value }
        @inlinable set { self.bagContainer.value = newValue }
    }
    
    @usableFromInline final class BagContainer {
        @usableFromInline var value = ObjectBag()
        
        @inlinable init() {}
    }
    
    @inlinable var bagContainer: BagContainer {
        if let container = objc_getAssociatedObject(self, &objectBagKey) as? BagContainer { return container }
        let container = BagContainer()
        objc_setAssociatedObject(self, &objectBagKey, container, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return container
    }
}
