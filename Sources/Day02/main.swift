import Foundation

let fileURL = URL(fileURLWithPath: "day02_input.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.split(separator: "\n")

extension Array {
    func adjacentPairs() -> [(Element, Element)] {
        guard count > 1 else { return [] }
        return (0..<count-1).map { (self[$0], self[$0 + 1]) }
    }
}

// Part 1: 686
let part1 = lines.reduce(0) { count, line in
    let numbers = line.split(separator: " ").compactMap { Int($0) }
    let diffs = numbers.adjacentPairs().map { $0.0 - $0.1 }
    let safe = diffs.allSatisfy({ $0 > 0 && $0 <= 3 }) || diffs.allSatisfy({ $0 < 0 && abs($0) <= 3 })
    return safe ? count + 1 : count
}

print("Part 1: \(part1)")

// Part 2: 717
let part2 = lines.reduce(0) { count, line in
    let numbers = line.split(separator: " ").compactMap { Int($0) }
    let diffs = numbers.adjacentPairs().map { $0.0 - $0.1 }
    let safe = diffs.allSatisfy({ $0 > 0 && $0 <= 3 }) || diffs.allSatisfy({ $0 < 0 && abs($0) <= 3 }) || tryRemovingOne(numbers)
    return safe ? count + 1 : count
}

func tryRemovingOne(_ numbers: [Int]) -> Bool {
    for i in numbers.indices {
        var tempNumbers = numbers
        tempNumbers.remove(at: i)
        let diffs = tempNumbers.adjacentPairs().map { $0.0 - $0.1 }
        if diffs.allSatisfy({ $0 > 0 && $0 <= 3 }) || diffs.allSatisfy({ $0 < 0 && abs($0) <= 3 }) {
            return true
        }
    }
    return false
}

print("Part 2: \(part2)")

