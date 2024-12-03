import Foundation
import RegexBuilder

let fileURL = URL(fileURLWithPath: "day03_input.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)

let test1 = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
let test2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

print("Part 1 -------------------")
print("Test: \(part1(test1))") // 161
print("Input: \(part1(fileContents))") // 189527826


print("Part 2 -------------------")
print("Test2: \(part2(test2))") // 48
print("Input2: \(part2(fileContents))") // 63013756


func part1(_ input: String) -> Int {
    let pattern =  /mul\(\d{1,3},\d{1,3}\)/  
    let matches = input.matches(of: pattern)
    let substrings = matches.map { match in
        String(match.output)
    }

    let total = substrings.reduce(0) { result, substring in
        let numbers = extractNumbers(String(substring))
        return result + (numbers[0] * numbers[1])
    }

    return total
}


func part2(_ input: String) -> Int {
    let pattern =  /mul\(\d{1,3},\d{1,3}\)|don't\(\)|do\(\)/
    let matches = input.matches(of: pattern)
    let substrings = matches.map { match in
        String(match.output)
    }

    var total = 0
    var execute = true
    for substring in substrings {
        if substring == "don't()" {
            execute = false
            continue
        } else if substring == "do()" {
            execute = true
            continue
        } 
        
        if (execute) {
            let numbers = extractNumbers(String(substring))
            total += numbers[0] * numbers[1]
        }        
    }
    return total
} 

func extractNumbers(_ input: String) -> [Int] {
    let cleanedSubstring = input
        .replacingOccurrences(of: "mul(", with: "")
        .replacingOccurrences(of: ")", with: "")
        .split(separator: ",")
    return cleanedSubstring.compactMap { Int($0) }
}