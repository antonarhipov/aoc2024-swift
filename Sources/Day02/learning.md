1. map vs compactMap

map() takes a value out of a container, applies a function to it, then puts the result of that function back into a new container that gets returned to you.

compactMap() is a specialized form of map(). compactMap() applies a compacting step once the map() operation has been completed: all optionals get unwrapped, and any that contained nil get discarded.


2. !!!!! No sliding window function in the stdlib is painful!

    let windowSize = 2
    let diffs = (0..<(numbers.count - windowSize + 1)).map { i in
        let window = Array(numbers[i..<i + windowSize])
        return window[0] - window[1]
    }

3. allSatisfy

```
let names = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
let allHaveAtLeastFive = names.allSatisfy({ $0.count >= 5 })
```

[https://developer.apple.com/documentation/swift/array/allsatisfy(_:)](https://developer.apple.com/documentation/swift/array/allsatisfy(_:)) 

