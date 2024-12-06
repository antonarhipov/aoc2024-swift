import Foundation

let fileURL = URL(fileURLWithPath: "day06_input.txt")
// let fileURL = URL(fileURLWithPath: "day06_test.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.components(separatedBy: "\n")

// Directions
enum Direction: Character {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"
}

let obstruction: Character = "#"

// Create matrix from input lines
let matrix = lines.map { Array($0) }

let rows = matrix.count
let columns = matrix[0].count
print("Matrix: rows \(rows) columns \(columns)")

var position = (x: 0, y: 0)
var visited = Set<String>()

// find the starting position
if let startPosition = matrix.enumerated().flatMap({ (i, row) in
    row.enumerated().compactMap { (j, char) in
        ["^", ">", "v", "<"].contains(char) ? (i, j) : nil
    }
}).first {
    position.y = startPosition.0
    position.x = startPosition.1
}

var direction = Direction(rawValue: matrix[position.y][position.x])!

visited.insert("\(position.x),\(position.y)")
print("Initial position: \(position.x),\(position.y)")

while true {
    // Check if we reach the edge of the matrix
    if (position.x == 0 && direction == .left) ||
       (position.x == columns - 1 && direction == .right) ||
       (position.y == 0 && direction == .up) ||
       (position.y == rows - 1 && direction == .down) {
        break
    }

    // Move or turn based on the direction and obstructions
    switch direction {
        case .up:
            if matrix[position.y - 1][position.x] != obstruction {
                position.y -= 1
            } else {
                direction = .right
            }
        case .down:
            if matrix[position.y + 1][position.x] != obstruction {
                position.y += 1
            } else {
                direction = .left
            }
        case .left:
            if matrix[position.y][position.x - 1] != obstruction {
                position.x -= 1
            } else {
                direction = .up
            }
        case .right:
            if matrix[position.y][position.x + 1] != obstruction {
                position.x += 1
            } else {
                direction = .down
            }
    }

    visited.insert("\(position.x),\(position.y)")
}

print("Part 1: \(visited.count)")
