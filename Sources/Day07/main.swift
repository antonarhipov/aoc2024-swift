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

var total: Int64 = 0
for equation in equations {
    // generate all possible combinations of operators for this equation
    print("Calculating for equation: \(equation.left) = \(equation.right)")
    let operatorCombinations = generateOperatorCombinations(for: equation.right.count - 1)
    inner: for combination in operatorCombinations {
        print("Combination: \(combination)")
        let result = evaluateEquation(equation, with: combination)
        if result.0 {
            total += result.1
            break inner;
        }
    }
}
print("Part 1: \(total)")

func evaluateEquation(_ equation: Equation, with operators: [Character]) -> (Bool, Int64) {
        let left = Int(equation.left)!
        let right = equation.right.map { Int($0)! }
        var evaluationResult: Int64 = Int64(right.first!)

        for (index, operatorChar) in operators.enumerated() {
            if operatorChar == "+" {
                evaluationResult += Int64(right[index+1])
            } else if operatorChar == "*" {
                evaluationResult *= Int64(right[index+1])
            }
        }
        print("Equation: \(left) = \(right) -> \(evaluationResult) -> \(left == evaluationResult)")
        
        return (left == evaluationResult, evaluationResult)
}

func generateOperatorCombinations(for length: Int) -> [[Character]] {
    let operators: [Character] = ["+", "*"]
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

