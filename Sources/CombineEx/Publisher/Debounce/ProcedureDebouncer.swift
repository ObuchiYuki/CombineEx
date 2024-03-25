//
//  File.swift
//  
//
//  Created by yuki on 2024/01/14.
//

/// A class for manually debouncing.
///
///     let debounce = ProcedureDebouncer()
///     debounce { print("Sw") } // Sw
///
///     debounce.start()
///
///     debounce { print("Swif") }
///     debounce { print("Swift") }
///
///     debounce.end() // Swift
final public class ProcedureDebouncer: DebouncerProtocol {
    @usableFromInline var head: () -> () = {}
    
    @usableFromInline var debounceDepth = 0
        
    @inlinable public init() {}
    
    @inlinable public func execute(_ body: @escaping () -> ()) {
        if self.debounceDepth == 0 {
            body()
        } else {
            self.head = body
        }
    }
    
    @inlinable public func start() {
        self.debounceDepth += 1
    }
    
    @inlinable public func end() {
        self.debounceDepth -= 1
        
        if self.debounceDepth == 0 {
            self.head()
            self.head = {}
        }
    }
}
