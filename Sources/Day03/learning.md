1. [Regular expressions in Swift](https://www.hackingwithswift.com/swift/5.7/regexes)

    ```
    let pattern = /mul\(\d{1,3},\d{1,3}\)|don't\(\)|do\(\)/
    let matches = input.matches(of: pattern)
    let substrings = matches.map { match in
        String(match.output)
    }
    ```

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

