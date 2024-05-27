//
//  UIButton+Publisher.swift
//  ImageRotate
//
//  Created by yuki on 2024/03/26.
//

#if canImport(UIKit)
import UIKit
import Combine

extension UIControl {
    @usableFromInline static var actionPublisherKey = 0 as UInt8
    
    @inlinable public func actionPublisher(for event: UIControl.Event = .touchUpInside) -> some Publisher<Void, Never> {
        if let actionTarget = self.actionTarget { return actionTarget.subject }
        
        let actionTarget = ActionTarget()
        self.addTarget(actionTarget, action: #selector(ActionTarget.action(_:)), for: event)
        self.actionTarget = actionTarget
        return actionTarget.subject
    }
    
    @inlinable var actionTarget: ActionTarget? {
        @inlinable get {
            objc_getAssociatedObject(self, &UIControl.actionPublisherKey) as? ActionTarget
        }
        @inlinable set {
            objc_setAssociatedObject(self, &UIControl.actionPublisherKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @usableFromInline final class ActionTarget: NSObject {
        @usableFromInline let subject = PassthroughSubject<Void, Never>()
        
        @usableFromInline override init() { super.init() }
        
        @objc @inlinable func action(_ sender: UIControl) { self.subject.send() }
    }
}
#endif
