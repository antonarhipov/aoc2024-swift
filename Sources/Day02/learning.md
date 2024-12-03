1. map vs compactMap

map() takes a value out of a container, applies a function to it, then puts the result of that function back into a new container that gets returned to you.

compactMap() is a specialized form of map(). compactMap() applies a compacting step once the map() operation has been completed: all optionals get unwrapped, and any that contained nil get discarded.


2. !!!!! No sliding window function in the stdlib is painful! 

    let windowSize = 2
    let diffs = (0..<(numbers.count - windowSize + 1)).map { i in
        let window = Array(numbers[i..<i + windowSize])
        return window[0] - window[1]
    }

    Update: see #5 - it's part of the Algorithms package

3. allSatisfy

```
let names = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
let allHaveAtLeastFive = names.allSatisfy({ $0.count >= 5 })
```

[https://developer.apple.com/documentation/swift/array/allsatisfy(_:)](https://developer.apple.com/documentation/swift/array/allsatisfy(_:)) 


4. Extensions

```
extension Array {
    func adjacentPairs() -> [(Element, Element)] {
        guard count > 1 else { return [] }
        return (0..<count-1).map { (self[$0], self[$0 + 1]) }
    }
}
```

5. [Swift Algorithms package](https://github.com/apple/swift-algorithms/)

[Learned from the tweet by SwiftLang](https://x.com/SwiftLang/status/1863819687186116655)
