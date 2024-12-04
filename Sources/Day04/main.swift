import Foundation

let fileURL = URL(fileURLWithPath: "day04_input.txt")
// let fileURL = URL(fileURLWithPath: "day04_test2.txt")
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

let xmas = "XMAS"

let horizontalXmas = horizontal.countEntries(of: xmas)
let verticalXmas = vertial.countEntries(of: xmas)
let diagonalRightXmas = allDiagonals.countEntries(of: xmas)
let diagonalLeftXmas = allAntiDiagonals.countEntries(of: xmas)

let total = horizontalXmas + verticalXmas + diagonalRightXmas + diagonalLeftXmas
print("Part 1:  \(total)") // 18 (for test input)  2549 (with real input)

extension [String] {
    func countEntries(of substring: String) -> Int {
        return map { line in
            let streightCount = line.ranges(of: substring).count
            let reverseCount = line.reversed().ranges(of: substring).count 
            return streightCount + reverseCount
        }.reduce(0, +)
    }
}

// Part 2: find crossings of 'MAX' in the matrix
// The crossings are the intersections of the diagonal and anti-diagonal lines,
// Find two MAS in the shape of an X as follows:
// Example 1:
// M.S
// .A.
// M.S
// The number of crossings are: 1
// The two 'MAS' words are always diagonal and intersect at letter 'A'
// Example 2:
// .M.S......
// ..A..MSMS.
// .M.S.MAA..
// ..A.ASMSM.
// .M.S.M....
// ..........
// S.S.S.S.S.
// .A.A.A.A..
// M.M.M.M.M.
// ..........
// The number of crossings are: 9


let crossings = matrix.countCrossings(of: "MAS")
print("Part 2:  \(crossings)") 

extension Array where Element == Array<Character> {
    func countCrossings(of substring: String) -> Int {
        let rows = self.count
        let columns = self[0].count
        var count = 0
        for i in 0..<rows {
            for j in 0..<columns {
                if self[i][j] == "A" {            
                    if i + 1 < rows && j + 1 < columns && i - 1 >= 0 && j - 1 >= 0 {
                        let topLeft = self[i-1][j-1]
                        let bottomRight = self[i+1][j+1]
                        let topRight = self[i-1][j+1]
                        let bottomLeft = self[i+1][j-1]

                        if (   topLeft == "S" && bottomRight == "M" && topRight == "S" && bottomLeft == "M"  ||
                               topLeft == "S" && bottomRight == "M" && topRight == "M" && bottomLeft == "S"  ||

                               topLeft == "M" && bottomRight == "S" && topRight == "M" && bottomLeft == "S"  ||                               
                               topLeft == "M" && bottomRight == "S" && topRight == "S" && bottomLeft == "M"  ){
                            count += 1
                        }
                    } 
                }
            }
        }
        return count
    }
}
