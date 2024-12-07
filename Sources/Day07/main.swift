import Foundation
import Algorithms

let fileURL = URL(fileURLWithPath: "day07_input.txt")
// let fileURL = URL(fileURLWithPath: "day07_test.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)

struct Equation {
    var left: String
    var right: [String]
}

let equations = fileContents.split(separator: "\n").map {
    let parts = $0.split(separator: ":")
    let left: String = parts[0].trimmingCharacters(in: .whitespaces)
    let right = parts[1].trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
    return Equation(left: left, right: right)
}

// Part 1
print("Part 1 in progress...")
var timer: ContinuousClock = ContinuousClock()
var total1: Int64 = 0
let time1 = timer.measure {
    for equation in equations {
        let operatorCombinations = generateCombinations(for: ["+", "*"], by: equation.right.count - 1)
        total1 += validateAndCalculate(for: equation, with: operatorCombinations)
    }
}
print("Time elapsed: \(time1)")
print("Part 1: \(total1)")

// Part 2
print("Part 2 in progress...")
var total2: Int64 = 0
let time2 = timer.measure {
    for equation in equations {
        let operatorCombinations = generateCombinations(for: ["+", "*", "|"], by: equation.right.count - 1)
        total2 += validateAndCalculate(for: equation, with: operatorCombinations)
    }
}
print("Time elapsed: \(time2)")
print("Part 2: \(total2)")

func validateAndCalculate(for equation: Equation, with operatorCombinations: [[Character]]) -> Int64 {
    return operatorCombinations
        .map { combination in evaluateEquation(equation, with: combination) }
        .first { evaluationResult in evaluationResult.ok }? .result ?? 0
}

func evaluateEquation(_ equation: Equation, with operators: [Character]) -> (ok: Bool, result: Int64) {
        let left = Int(equation.left)!
        let right = equation.right.map { Int($0)! }
        var evaluationResult: Int64 = Int64(right.first!)

        for (index, operatorChar) in operators.enumerated() {
            if operatorChar == "+" {
                evaluationResult += Int64(right[index+1])
            } else if operatorChar == "*" {
                evaluationResult *= Int64(right[index+1])
            } else if operatorChar == "|" {
                evaluationResult = Int64(String(evaluationResult) + String(right[index+1]))!
            }
        }
        // print("Equation: \(left) = \(right) -> \(evaluationResult) -> \(left == evaluationResult)")
        return (left == evaluationResult, evaluationResult)
}

func generateCombinations(for operators: [Character], by length: Int) -> [[Character]] {
    var combinations: [[Character]] = []

    func generate(current: [Character]) {
        if current.count == length {
            combinations.append(current)
            return
        }

        for op in operators {
            generate(current: current + [op])
        }
    }

    generate(current: [])
    return combinations
}
