//
//  Combine+TextField.swift
//  CoreUtil
//
//  Created by yuki on 2021/01/03.
//  Copyright © 2021 yuki. All rights reserved.
//

#if canImport(AppKit)
import AppKit
import Combine

extension NSTextField {
    
    @usableFromInline static var delegatePublisherKey = 0 as UInt8
    
    public var beginEditingStringPublisher: some Publisher<String, Never> {
        self.pubilsherDelegate.beginEditingPublisher.map{ $0.stringValue }
    }
    
    public var changeStringPublisher: some Publisher<String, Never> {
        self.pubilsherDelegate.changePublisher.map{ $0.stringValue }
    }
    
    public var endEditingStringPublisher: some Publisher<String, Never> {
        self.pubilsherDelegate.endEditingPublisher.map{ $0.stringValue }
    }
    
    
    @inlinable public var endEditingPublisher: some Publisher<NSTextField, Never> {
        self.pubilsherDelegate.endEditingPublisher
    }
    
    @inlinable public var changePublisher: some Publisher<NSTextField, Never> {
        self.pubilsherDelegate.changePublisher
    }
    
    @inlinable public var beginEditingPublisher: some Publisher<NSTextField, Never> {
        self.pubilsherDelegate.beginEditingPublisher
    }
    
    @usableFromInline final class PublisherDelegate: NSObject, NSTextFieldDelegate {
        @usableFromInline let endEditingPublisher = PassthroughSubject<NSTextField, Never>()
        
        @usableFromInline let changePublisher = PassthroughSubject<NSTextField, Never>()
        
        @usableFromInline let beginEditingPublisher = PassthroughSubject<NSTextField, Never>()
        
        @usableFromInline override init() {
            super.init()
        }
        
        @inlinable func controlTextDidBeginEditing(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            beginEditingPublisher.send(textField)
        }
        
        @inlinable func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            changePublisher.send(textField)
        }
        
        @inlinable func controlTextDidEndEditing(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            endEditingPublisher.send(textField)
        }
    }
    
    @inlinable var pubilsherDelegate: PublisherDelegate {
        if let delegate = objc_getAssociatedObject(self, &NSTextField.delegatePublisherKey) as? PublisherDelegate { return delegate }
        
        let delegate = PublisherDelegate()
        objc_setAssociatedObject(self, &NSTextField.delegatePublisherKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        assert(self.delegate == nil, "Publisher delegate is not averable. \(delegate)")
        self.delegate = delegate
        return delegate
    }
}
#endif
