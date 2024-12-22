//
//  File.swift
//  CombineEx
//
//  Created by yuki on 2024/12/22.
//

import Combine

extension CurrentValueSubject: Value where Failure == Never {}

extension Just: Value {
    @inlinable public var value: Output { self.output }
}

extension Publishers.Map: Value where Upstream: Value {
    @inlinable public var value: Output {
        self.transform(self.upstream.value)
    }
}

extension Publishers.FlatMap: Value where Upstream: Value, NewPublisher: Value {
    @inlinable public var value: Output {
        self.transform(self.upstream.value).value
    }
}

extension Publishers.SwitchToLatest: Value where Upstream: Value, Upstream.Output: Value {
    @inlinable public var value: Output {
        self.upstream.value.value
    }
}

extension Publishers.CombineLatest: Value where A: Value, B: Value {
    @inlinable public var value: Output {
        (self.a.value, self.b.value)
    }
}

extension Publishers.CombineLatest3: Value where A: Value, B: Value, C: Value {
    @inlinable public var value: Output {
        (self.a.value, self.b.value, self.c.value)
    }
}

extension Publishers.CombineLatest4: Value where A: Value, B: Value, C: Value, D: Value {
    @inlinable public var value: Output {
        (self.a.value, self.b.value, self.c.value, self.d.value)
    }
}

extension Publishers.Zip: Value where A: Value, B: Value {
    @inlinable public var value: Output {
        (self.a.value, self.b.value)
    }
}

extension Publishers.Zip3: Value where A: Value, B: Value, C: Value {
    @inlinable public var value: Output {
        (self.a.value, self.b.value, self.c.value)
    }
}

extension Publishers.Zip4: Value where A: Value, B: Value, C: Value, D: Value {
    @inlinable public var value: Output {
        (self.a.value, self.b.value, self.c.value, self.d.value)
    }
}

extension Publishers.RemoveDuplicates: Value where Upstream: Value {
    @inlinable public var value: Output {
        self.upstream.value
    }
}

extension Publishers.ReplaceError where Upstream: Value {
    @inlinable public var value: Output {
        return self.upstream.value
    }
}

extension Publishers.First: Value where Upstream: Value {
    @inlinable public var value: Output {
        return self.upstream.value
    }
}

extension Publishers.Print: Value where Upstream: Value {
    @inlinable public var value: Output {
        return self.upstream.value
    }
}

extension Publishers.Share: Value where Upstream: Value {
    @inlinable public var value: Output {
        return self.upstream.value
    }
}
