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

print("Part 3 -----(no regex)-----")
print("Test1: \(noregex_part1(test1))") // 161
print("Test2: \(noregex_part2(test2))") // 48
print("Input1: \(noregex_part1(fileContents))") // 189527826
print("Input2: \(noregex_part2(fileContents))") // 63013756


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
        } else if substring == "do()" {
            execute = true            
        } else if execute {
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


///---------------------------------------------------------------------
///                   !!!!!HERE BE DRAGONS!!!!!
/// A very alternative implementation without regular expressions :)
///---------------------------------------------------------------------


func noregex_part1(_ input: String) -> Int {
    var i = 0
    var total = 0

    for char in input {
        // find "mul("
        if char == "m" {
            let next = input.index(input.startIndex, offsetBy: i + 4)
            if input[input.index(input.startIndex, offsetBy: i)..<next] == "mul(" {
                var start = next
                var end = start
                // find the first number
                while input[end] != "," {
                    end = input.index(after: end)
                }        
                let firstNumber = Int(input[start..<end])                
                if firstNumber == nil { 
                    i += 1
                    continue 
                }

                // find the second number
                start = input.index(after: end)
                end = start
                
                while input[end] != ")" && input[end].isNumber {
                    end = input.index(after: end)
                }
                let secondNumber: Int? = Int(input[start..<end])            
                if secondNumber == nil { 
                    i += 1
                    continue 
                }

                let ok = input[end] == ")"

                if ok && firstNumber != nil && secondNumber != nil {
                    total += firstNumber! * secondNumber!
                }
            }            
        }
        i += 1
    }

    return total
}


func noregex_part2(_ input: String) -> Int {
    var i = 0
    var total = 0
    var enabled = true

    for char in input {
        if char == "d" {            
            let nextForDont = input.index(input.startIndex, offsetBy: i + 7)                        
            if input[input.index(input.startIndex, offsetBy: i)..<nextForDont] == "don't()" {        
                enabled = false
                i += 1
                continue
            }
            
            let nextForDo = input.index(input.startIndex, offsetBy: i + 4)            
            if input[input.index(input.startIndex, offsetBy: i)..<nextForDo] == "do()" {
                enabled = true
                i += 1
                continue
            }             
        }

        // first, find "mul("
        if char == "m" {
            let next = input.index(input.startIndex, offsetBy: i + 4)
            if input[input.index(input.startIndex, offsetBy: i)..<next] == "mul(" {
                var start = next
                var end = start
                // find the first number
                while input[end] != "," {
                    end = input.index(after: end)
                }        
                let firstNumber = Int(input[start..<end])
                if firstNumber == nil { 
                    i += 1
                    continue 
                }

                // find the second number
                start = input.index(after: end)
                end = start
                
                while input[end] != ")" && input[end].isNumber {
                    end = input.index(after: end)
                }
                let secondNumber: Int? = Int(input[start..<end])
                if secondNumber == nil { 
                    i += 1
                    continue 
                }

                let ok = input[end] == ")"

                if ok && firstNumber != nil && secondNumber != nil && enabled {
                    total += firstNumber! * secondNumber!
                }
            }            
        }
        i += 1
    }

    return total
}
