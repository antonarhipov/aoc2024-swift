import Foundation

let fileURL = URL(fileURLWithPath: "day06_input.txt")
// let fileURL = URL(fileURLWithPath: "day06_test.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.components(separatedBy: "\n")

//directions
let up: Character = "^"
let down: Character = "v"
let left: Character = "<"
let right: Character = ">"

let obstruction: Character = "#"

let matrix = lines.map { line in
    line.map { $0 }
}

let rows = matrix.count
let columns = matrix[0].count
print("Matrix: rows \(rows) columns \(columns)")

var x = 0
var y = 0
var visited = Set<String>()

// find the starting position
for i in 0..<rows {
    for j in 0..<columns {
        if matrix[i][j] == "^" || matrix[i][j] == ">" || matrix[i][j] == "v" || matrix[i][j] == "<" {
            x = j
            y = i
            break
        }
    }
}

var direction = matrix[y][x]

visited.insert("\(x),\(y)")
print("Initial position")
print("\(x),\(y)")

while true {
    // if we reach the edge of the matrix, exit
    
    if x == 0 && direction == left 
    || x == columns-1 && direction == right
    || y == 0 && direction == up
    || y == rows-1 && direction == down {
        break
    }

    // if the next cell is an obstruction, turn right
    switch direction {
        case up:
            if matrix[y - 1][x] != obstruction {
                y -= 1
            } else {
                direction = right
            }
        case down:
            if matrix[y + 1][x] != obstruction {
                y += 1
            } else {
                direction = left
            }
        case left:
            if matrix[y][x - 1] != obstruction {
                x -= 1
            } else {
                direction = up
            }
        case right:
            if matrix[y][x + 1] != obstruction {
                x += 1
            } else {
                direction = down
            }
        default:    
            break
    }
    
    visited.insert("\(x),\(y)")
    // print("\(x),\(y)")
}

print("Part 1: \(visited.count)")