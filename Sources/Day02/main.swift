import Foundation
import Algorithms

let fileURL = URL(fileURLWithPath: "day02_input.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.split(separator: "\n")

func isSafe(_ numbers: [Int]) -> Bool {
    let diffs = numbers.adjacentPairs().map { $0.0 - $0.1 }
    return diffs.allSatisfy({ $0 > 0 && $0 <= 3 }) || diffs.allSatisfy({ $0 < 0 && abs($0) <= 3 })
}

// Part 1: 686
let part1 = lines.reduce(0) { count, line in
    let numbers = line.split(separator: " ").compactMap { Int($0) }
    return isSafe(numbers) ? count + 1 : count
}

print("Part 1: \(part1)")

// Part 2: 717
let part2 = lines.reduce(0) { count, line in
    let numbers = line.split(separator: " ").compactMap { Int($0) }
    let safe = isSafe(numbers) || tryRemovingOne(numbers)
    return safe ? count + 1 : count
}

func tryRemovingOne(_ numbers: [Int]) -> Bool {
    for i in numbers.indices {
        var tempNumbers = numbers
        tempNumbers.remove(at: i)

        if(isSafe(tempNumbers)) { 
            return true 
        }        
    }
    return false
}

print("Part 2: \(part2)")

