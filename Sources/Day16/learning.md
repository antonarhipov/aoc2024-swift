1. `@escaping` annotation for lambda stored in a property
    
    ```
    struct MyStruct {
        let lambda: (Int) -> Bool
        
        
        init(lambda: @escaping (Int) -> Bool) {
            self.lambda = lambda
        }
    }
    ```