import Foundation

func generateNextSecret(_ current: Int) -> Int {
    var secret = current
    
    // Step 1: Multiply by 64, mix, and prune
    let step1 = secret * 64
    secret = (secret ^ step1) % 16777216
    
    // Step 2: Divide by 32, mix, and prune
    let step2 = secret / 32
    secret = (secret ^ step2) % 16777216
    
    // Step 3: Multiply by 2048, mix, and prune
    let step3 = secret * 2048
    secret = (secret ^ step3) % 16777216
    
    return secret
}

func solve(input: String) -> Int {
    let numbers = input.split(separator: "\n").compactMap { Int($0) }
    var result = 0
    
    for initialSecret in numbers {
        var secret = initialSecret
        // Generate 2000 new numbers
        for _ in 0..<2000 {
            secret = generateNextSecret(secret)
        }
        result += secret
    }
    
    return result
}

// Test input
let testInput = """
1
10
100
2024
"""

let testResult = solve(input: testInput)
print("Test result: \(testResult)")
assert(testResult == 37327623, "Test case failed")

// Real input
if let input = try? String(contentsOfFile: "day22_input.txt", encoding: .utf8) {
    let result = solve(input: input)
    print("Result: \(result)")
}
