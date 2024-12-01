import Foundation

let fileURL = URL(fileURLWithPath: "day01_test.txt")

let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.split(separator: "\n")

// split each lines into two collections of numbers by column
var leftcolumn: [Int] = []
var rightcolumn: [Int] = []

for line in lines {
    let numbers = line.split(separator: " ").map { Int($0)! }
    leftcolumn.append(numbers[0])
    rightcolumn.append(numbers[1])    
}

// solution 1
let diffs = zip(leftcolumn.sorted(), rightcolumn.sorted()).map { abs($0 - $1) }
print("Solution 1: \(diffs.reduce(0, +))")


// solution 2
let counters = leftcolumn.map { 
    number in 
    number * rightcolumn.filter { $0 == number }.count
}

print("Solution 2: \(counters.reduce(0, +))")
