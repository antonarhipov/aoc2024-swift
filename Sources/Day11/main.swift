import Foundation

// Read and parse input
let input = "64554 35 906 6 6960985 5755 975820 0"
var stones = input.split(separator: " ").map { Int($0)! }

// Part 1
print(stones.map { String($0) }.joined(separator: " "))
for i in 0..<25 {
    stones = evaluate(stones)
    print("\(i): \(stones.count)")
}
print("Part 1: \(stones.count)")


func evaluate(_ stones: [Int]) -> [Int] {
    var result: [Int] = []
    for stone in stones {
        if stone == 0 {
            result.append(1)
        } else if isEvenDigitCount(stone) {
            let (left, right) = splitNumber(stone)
            result.append(left)
            result.append(right)
        } else {
            result.append(stone * 2024)
        }
    }
    return result
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
