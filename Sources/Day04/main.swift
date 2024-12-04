import Foundation

let fileURL = URL(fileURLWithPath: "day04_input.txt")
// let fileURL = URL(fileURLWithPath: "day04_test.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)

let horizontal = fileContents.split(separator: "\n").map { String($0) }


let matrix = horizontal.map { line in
    line.map { $0 }
}

//matrix size
let rows = matrix.count
let columns = matrix[0].count
print("Matrix: rows \(rows) columns \(columns)")

let vertial = matrix[0].indices.map { i in
    matrix.indices.map { j in
        matrix[j][i]
    }
}.map { line in
    String(line)
}

// all diagonals of the matrix example
// Matrix example: with 5 rows and 5 columns
// X M A S X
// M M A M X
// P L A M M
// E D A S A
// T S U L S
// The diagonals are:
// X
// M M
// P M A
// E L A S
// T D A M X
// S A M X
// U S M
// L A
// S
let allDiagonalsTmp = (0..<rows).map { i in
    var line = ""
    for j in 0...i {
        line.append(matrix[i-j][j])
    }
    return line
} + (1..<columns).map { i in
    var line = ""
    for j in 0...(columns - i - 1) {
        line.append(matrix[rows - j - 1][i + j])
    }
    return line
}
let allDiagonals = allDiagonalsTmp.filter { $0.count > 3 }


let allAntiDiagonalsTmp = (0..<rows).map { i in
    var line = ""
    for j in 0...i {
        line.append(matrix[i-j][columns - j - 1])
    }
    return line
} + (1..<columns).map { i in
    var line = ""
    for j in 0...(columns - i - 1) {
        line.append(matrix[rows - j - 1][columns - i - j - 1])
    }
    return line
}

let allAntiDiagonals = allAntiDiagonalsTmp.filter { $0.count > 3 }

print("----------------------")
print("Horizontal: \(horizontal.count)")
horizontal.forEach { print($0) }
print("----------------------")
print("Vertical: \(vertial.count)")
vertial.forEach { print($0) }
print("----------------------")
print("Diagonals: \(allDiagonals.count)")
allDiagonals.forEach { print($0) }
print("----------------------")
print("Anti Diagonals: \(allAntiDiagonals.count)")
allAntiDiagonals.forEach { print($0) }
print("----------------------")

let xmas = "XMAS"

let horizontalXmas = horizontal.countEntries(of: xmas)
let verticalXmas = vertial.countEntries(of: xmas)
let diagonalRightXmas = allDiagonals.countEntries(of: xmas)
let diagonalLeftXmas = allAntiDiagonals.countEntries(of: xmas)

let total = horizontalXmas + verticalXmas + diagonalRightXmas + diagonalLeftXmas
print("Part 1:  \(total)")

extension [String] {
    func countEntries(of substring: String) -> Int {
        return map { line in
            let streightCount = line.ranges(of: substring).count
            let reverseCount = line.reversed().ranges(of: substring).count 
            print("-> \(line) -> \(streightCount)")
            print("<- \(String(line.reversed())) -> \(reverseCount)")        
            return streightCount + reverseCount
        }.reduce(0, +)
    }
}
