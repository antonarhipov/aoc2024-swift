import Foundation
import Algorithms

// let fileURL = URL(fileURLWithPath: "day08_test.txt")
let fileURL = URL(fileURLWithPath: "day08_input.txt")

let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.split(separator: "\n")

print("Part 1 in progress...")

//create two-dimentional array of characters from the input lines
let matrix = lines.map { line in
    line.map { $0 }
}

var matrixCopy = matrix
var markedSymols: [Character] = []

matrix.enumerated().forEach { (i, row) in
    row.enumerated().forEach { (j, cell) in
        guard cell != "." && cell != "#" && !markedSymols.contains(cell) else { return }

        markedSymols.append(cell)

        let antennas = findSameAnttennaes(symbol: cell, matrix: matrix)
        antennas.combinations(ofCount: 2).forEach { combination in
            let distance = findDistance(combination: combination)
            let (y1, x1) = combination[0]
            let (y2, x2) = combination[1]
            let (dy, dx) = distance
            let (y3, x3) = (y1 - dy, x1 - dx)
            updateMatrixIfPossible(cell, y3, x3)
            let (y4, x4) = (y2 + dy, x2 + dx)
            updateMatrixIfPossible(cell, y4, x4)
        }
    }
}

// print matrix
matrixCopy.forEach { row in
    row.forEach { cell in
        print(cell, terminator: "")
    }
    print()
}

let counter = matrixCopy.flatMap { $0 }.filter { $0 == "#" }.count
print("Counter: \(counter)")

func updateMatrixIfPossible(_ currentSymbol: Character, _ y: Int, _ x: Int) {
    guard y >= 0 && y < matrix.count && x >= 0 && x < matrix[0].count else {
        return
    }
    
    if matrix[y][x] != currentSymbol {
        matrixCopy[y][x] = "#"        
    }
}


func findDistance(combination: [(Int, Int)]) -> (Int, Int) {
    let (y1, x1) = combination[0]
    let (y2, x2) = combination[1]
    let distance = ((y2 - y1) , (x2 - x1))
    return distance
}

func findSameAnttennaes(symbol: Character, matrix: [[Character]]) -> [(Int, Int)] {
    return matrix.enumerated().flatMap { (i, row) in
        row.enumerated().compactMap { (j, cell) in
            cell == symbol ? (i, j) : nil
        }
    }
}
