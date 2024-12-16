import Foundation

struct MyStruct {
    let lambda: (Int) -> Bool
    
    
    init(lambda: @escaping (Int) -> Bool) {
        self.lambda = lambda
    }
}

