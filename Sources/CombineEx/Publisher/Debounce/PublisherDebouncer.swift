//
//  File.swift
//  
//
//  Created by yuki on 2024/01/14.
//

import Combine

final public class PublisherDebouncer: DebouncerProtocol {
    @usableFromInline var isDebouncing = false
    
    @usableFromInline var body: (() -> ())? = nil
    
    @usableFromInline var cancellable: AnyCancellable?
    
    @inlinable convenience public init<P: Publisher>(_ publisher: P) where P.Output == Bool, P.Failure == Never {
        self.init(publisher, debounceWhen: { $0 })
    }
    
    @inlinable public init<P: Publisher>(_ publisher: P, debounceWhen condition: @escaping (P.Output) -> Bool) where P.Failure == Never {
        self.cancellable = publisher
            .sink{ output in
                let flag = condition(output)
                
                if flag == true {
                    self.isDebouncing = true
                } else if self.isDebouncing == true {
                    self.body?()
                    self.body = nil
                }
                
                self.isDebouncing = flag
            }
    }
    
    @inlinable public func execute(_ body: @escaping () -> ()) {
        if self.isDebouncing == true {
            self.body = body
        } else {
            body()
        }
    }
}
