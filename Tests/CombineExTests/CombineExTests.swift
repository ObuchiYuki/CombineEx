import Testing
import Combine
import CombineEx

@Test func Combine_Test() { // ✅ グローバル関数として定義可能
    let p1 = Just(1)
    let p2 = p1
        .map{
            print("map", $0)
            return $0 + 1
        }
    
    print("value1", p2.unsafeValue().value)
    print("value2", p2.unsafeValue().value)
}
