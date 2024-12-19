import Foundation


// Read input
// let input = try String(contentsOfFile: "day19_test.txt", encoding: .utf8)
let input = try String(contentsOfFile: "day19_input.txt", encoding: .utf8)
let lines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
print("Found \(lines.count) lines")

//the first line is the comma separated list of available patterns
let patterns = lines[0].split(separator: ",")
    .map { String($0.trimmingCharacters(in: .whitespaces)) }
    .sorted { $0.count > $1.count }
print("Available patterns: \(patterns)")

//the other lines are the designs
let designs = lines[1...].map { $0 }
print("Designs to check: \(designs)")


let solver = Solver(patterns: patterns)
var possibleCount = 0
var impossibleCount = 0

// Part 1
print("Part 1:")
for design in designs {
    let canMake = solver.canCompose(design)
    if canMake {
        possibleCount += 1
    } else {
        impossibleCount += 1
    }
}

print("Found \(possibleCount) designs that can be made using the available patterns")
print("\(impossibleCount) designs that cannot be made using the available patterns")

// Part 2
print("\nPart 2:")
var totalWays = 0
for design in designs {
    let ways = solver.countWays(design)
    totalWays += ways
}

print("Total number of different ways to make all designs: \(totalWays)")

class Solver {
    let patterns: [String]
    var cache: [String: Bool] = [:]
    var waysCache: [String: Int] = [:]
    
    init(patterns: [String]) {
        self.patterns = patterns
    }
    
    func canCompose(_ design: String) -> Bool {
        //Check cache first
        if let cached = cache[design] {
            return cached
        }
        
        // Base cases
        if design.isEmpty {
            return true
        }
        
        // Try each pattern at the start
        for pattern in patterns {
            if design.hasPrefix(pattern) {
                let remaining = String(design.dropFirst(pattern.count))
                if canCompose(remaining) {
                    cache[design] = true
                    return true
                }
            }
        }
        
        // If no pattern works, this design cannot be made
        cache[design] = false
        return false
    }


    func countWays(_ design: String) -> Int {
        // Check cache first
        if let cached = waysCache[design] {
            return cached
        }
        
        // Base cases
        if design.isEmpty {
            return 1  // Empty string can be made in exactly one way
        }
        
        var totalWays = 0
        
        // Try each pattern at the start
        for pattern in patterns {
            if design.hasPrefix(pattern) {
                let remaining = String(design.dropFirst(pattern.count))
                totalWays += countWays(remaining)
            }
        }
        
        waysCache[design] = totalWays
        return totalWays
    }
}