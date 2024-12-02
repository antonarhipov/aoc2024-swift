import Foundation

let fileURL = URL(fileURLWithPath: "day02_test.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.split(separator: "\n")

// Part 1
for line in lines {
    let numbers = line.split(separator: " ").compactMap { Int($0) }
    
    
    let windowSize = 2
    let diffs = (0..<(numbers.count - windowSize + 1)).map { i in
        let window = Array(numbers[i..<i + windowSize])
        return window[0] - window[1]
    }

    print(diffs)
}

