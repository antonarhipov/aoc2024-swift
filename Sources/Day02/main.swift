import Foundation

let fileURL = URL(fileURLWithPath: "day02_input.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.split(separator: "\n")


let validCount = lines.reduce(0) { count, line in
    let numbers = line.split(separator: " ").compactMap { Int($0) }
    
    let windowSize = 2
    let diffs = (0..<(numbers.count - windowSize + 1)).map { i in
        let window = Array(numbers[i..<i + windowSize])
        return window[0] - window[1]
    }

    let safe = diffs.allSatisfy({ $0 > 0 && $0 <= 3 }) || diffs.allSatisfy({ $0 < 0 && abs($0) <= 3 })
    return safe ? count + 1 : count
}

print(validCount)