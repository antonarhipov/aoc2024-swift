import Foundation

// Read and parse input
let input = "64554 35 906 6 6960985 5755 975820 0"
var stones = input.split(separator: " ").map { Stone(value: Int($0)!) }

var cache = [Int: [Int]]()
var evaluationsCount = 0
var cacheHits = 0

    
print("Initial stones:", stones.map { $0.value })

// Part 1
print("\nCalculating Part 1 (25 blinks)...")
let part1Result = simulateStones(stones, blinks: 25)
print("Part 1:", part1Result)

// Part 2
print("\nCalculating Part 2 (75 blinks)...")
let part2Result = simulateStones(stones, blinks: 75)
print("Part 2:", part2Result)


func simulateStones(_ stones: [Stone], blinks: Int) -> Int {
    var cache: [CacheKey: Int] = [:]
    
    func simulateStone(_ stone: Stone, remainingBlinks: Int) -> Int {
        if remainingBlinks == 0 {
            return 1
        }
        
        let key = CacheKey(stone: stone, remainingBlinks: remainingBlinks)
        if let cached = cache[key] {
            return cached
        }
        
        let result = stone.transform.reduce(0) { sum, newStone in
            sum + simulateStone(newStone, remainingBlinks: remainingBlinks - 1)
        }
        
        cache[key] = result
        return result
    }
    
    var totalStones = 0
    for (i, stone) in stones.enumerated() {
        let count = simulateStone(stone, remainingBlinks: blinks)
        totalStones += count
        
        // Print progress for each stone
        print("Processed stone \(i + 1)/\(stones.count): \(stone.value) -> contributes \(count) stones")
    }
    
    return totalStones
}


func evaluate(_ stones: [Int]) -> [Int] {
    var result: [Int] = []
    for stone in stones {
        if let cached = cache[stone] {
            cacheHits += 1
            result.append(contentsOf: cached)
        } else {
            let evaluated = evaluateStone(stone: stone)
            cache[stone] = evaluated
            result.append(contentsOf: evaluated)
        }
    }
    return result
}

func evaluateStone(stone: Int) -> [Int] {
    evaluationsCount += 1
    if stone == 0 {
        return [1]
    } else if isEvenDigitCount(stone) {
        let (left, right) = splitNumber(stone)
        return [left, right]
    } else {
        return [stone * 2024]
    }
}

func isEvenDigitCount(_ number: Int) -> Bool {
    var count = 0
    var num = number
    while num > 0 {
        count += 1
        num /= 10
    }
    return count % 2 == 0
}

func splitNumber(_ number: Int) -> (Int, Int) {
    let digits = Array(String(number))
    let half = digits.count / 2
    let left = Int(String(digits[0..<half]))!
    let right = Int(String(digits[half..<digits.count]))!
    return (left, right)
}

struct Stone: Hashable {
    let value: Int
    
    var transform: [Stone] {
        if value == 0 {
            return [Stone(value: 1)]
        }
        
        let digits = String(value)
        if digits.count % 2 == 0 {
            let mid = digits.count / 2
            let leftStr = String(digits.prefix(mid))
            let rightStr = String(digits.suffix(mid))
            return [
                Stone(value: Int(leftStr)!),
                Stone(value: Int(rightStr)!)
            ]
        }
        
        return [Stone(value: value * 2024)]
    }
}

// Cache structure to store results for each stone at each blink
struct CacheKey: Hashable {
    let stone: Stone
    let remainingBlinks: Int
}

