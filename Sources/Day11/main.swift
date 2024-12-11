import Foundation

// Read and parse input
let input = "64554 35 906 6 6960985 5755 975820 0"
var stones = input.split(separator: " ").map { Int($0)! }

var cache = [Int: [Int]]()
var evaluationsCount = 0
var cacheHits = 0

// Part 1
print(stones.map { String($0) }.joined(separator: " "))
for i in 0..<75 {
    stones = evaluate(stones)
    print("\(i): \(stones.count), cache hits: \(cacheHits), evaluations: \(evaluationsCount)")
}
print("Part 1: \(stones.count)")
print("Evaluations: \(evaluationsCount)")
print("Cache hits: \(cacheHits)")


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
