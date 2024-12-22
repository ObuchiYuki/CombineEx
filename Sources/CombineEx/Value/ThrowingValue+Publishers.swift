//
//  File.swift
//  CombineEx
//
//  Created by yuki on 2024/12/22.
//

import Combine

extension CurrentValueSubject: ThrowingValue {}

extension Publishers.Map: ThrowingValue where Upstream: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try self.transform(self.upstream.value) }
    }
}

extension Publishers.TryMap: ThrowingValue where Upstream: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try self.transform(self.upstream.value) }
    }
}


extension Publishers.MapError: ThrowingValue where Upstream: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try self.upstream.value }
    }
}

extension Publishers.MapError: Value where Upstream: ThrowingValue, Failure == Never {
    @inlinable public var value: Output {
        do {
            return try self.upstream.value
        } catch {
            self.transform(error as! Upstream.Failure)
        }
    }
}

extension Publishers.FlatMap: ThrowingValue where Upstream: ThrowingValue, NewPublisher: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try self.transform(self.upstream.value).value }
    }
}

extension Publishers.SwitchToLatest: ThrowingValue where Upstream: ThrowingValue, Upstream.Output: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try self.upstream.value.value }
    }
}

extension Publishers.CombineLatest: ThrowingValue where A: ThrowingValue, B: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try (self.a.value, self.b.value) }
    }
}

extension Publishers.CombineLatest3: ThrowingValue where A: ThrowingValue, B: ThrowingValue, C: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try (self.a.value, self.b.value, self.c.value) }
    }
}

extension Publishers.CombineLatest4: ThrowingValue where A: ThrowingValue, B: ThrowingValue, C: ThrowingValue, D: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try (self.a.value, self.b.value, self.c.value, self.d.value) }
    }
}

extension Publishers.Zip: ThrowingValue where A: ThrowingValue, B: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try (self.a.value, self.b.value) }
    }
}

extension Publishers.Zip3: ThrowingValue where A: ThrowingValue, B: ThrowingValue, C: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try (self.a.value, self.b.value, self.c.value) }
    }
}

extension Publishers.Zip4: ThrowingValue where A: ThrowingValue, B: ThrowingValue, C: ThrowingValue, D: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try (self.a.value, self.b.value, self.c.value, self.d.value) }
    }
}

extension Publishers.RemoveDuplicates: ThrowingValue where Upstream: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try self.upstream.value }
    }
}

extension Publishers.ReplaceError: Value where Upstream: ThrowingValue {
    @inlinable public var value: Output {
        do {
            return try self.upstream.value
        } catch {
            return self.output
        }
    }
}

extension Publishers.First: ThrowingValue where Upstream: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try self.upstream.value }
    }
}

extension Publishers.Print: ThrowingValue where Upstream: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try self.upstream.value }
    }
}

extension Publishers.Share: ThrowingValue where Upstream: ThrowingValue {
    @inlinable public var value: Output {
        get throws { try self.upstream.value }
    }
}

extension Publishers.Catch: Value where Upstream: ThrowingValue, NewPublisher: Value {
    @inlinable public var value: Output {
        do {
            return try self.upstream.value
        } catch {
            guard let error = error as? Upstream.Failure else {
                fatalError("Unexpected error type")
            }
            return self.handler(error).value
        }
    }
}
