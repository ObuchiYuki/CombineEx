//
//  NSButton+Combine.swift
//  CoreUtil
//
//  Created by yuki on 2021/07/23.
//  Copyright © 2021 yuki. All rights reserved.
//

#if canImport(AppKit)
import AppKit
import Combine

@usableFromInline var actionPublisherKey = 0 as UInt8

extension NSControl {
    @usableFromInline
    final class Target: NSObject {
        @usableFromInline let subject = PassthroughSubject<Void, Never>()
        
        @usableFromInline override init() {
            super.init()
        }
        
        @objc @inlinable func action(_ sender: NSControl) { self.subject.send() }
    }
    
    @inlinable var actionTarget: Target? {
        @inlinable get { objc_getAssociatedObject(self, &actionPublisherKey) as? Target }
        @inlinable set { objc_setAssociatedObject(self, &actionPublisherKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @inlinable final public var actionPublisher: some Combine.Publisher<Void, Never> {
        if let target = self.actionTarget { return target.subject }
        
        let target = Target()
        self.actionTarget = target
        
        self.target = target
        self.action = #selector(Target.action)
        
        return target.subject
    }    
}
#endif
