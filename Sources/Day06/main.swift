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
visited = traverse(position: position, direction: direction, visited: visited)
print("Part 1: \(visited.count)")

func traverse(position: (x: Int, y: Int), direction: Direction, visited: Set<String>) -> Set<String> {
    var newVisited = visited
    var currentPosition = position
    var currentDirection = direction

    while true {
        if isEdge(position: currentPosition, direction: currentDirection) {
            break
        }

        let result = move(position: currentPosition, direction: currentDirection)
        currentPosition = result.0
        currentDirection = result.1

        newVisited.insert("\(currentPosition.x),\(currentPosition.y)")
    }

    return newVisited
}

func isEdge(position: (x: Int, y: Int), direction: Direction) -> Bool {
    return (position.x == 0 && direction == .left) ||
           (position.x == columns - 1 && direction == .right) ||
           (position.y == 0 && direction == .up) ||
           (position.y == rows - 1 && direction == .down)
}

func move(position: (x: Int, y: Int), direction: Direction) -> ((x: Int, y: Int), Direction) {
    var newPosition = position
    var newDirection = direction

    switch direction {
        case .up:
            if matrix[position.y - 1][position.x] != obstruction {
                newPosition.y -= 1
            } else {
                newDirection = .right
            }
        case .down:
            if matrix[position.y + 1][position.x] != obstruction {
                newPosition.y += 1
            } else {
                newDirection = .left
            }
        case .left:
            if matrix[position.y][position.x - 1] != obstruction {
                newPosition.x -= 1
            } else {
                newDirection = .up
            }
        case .right:
            if matrix[position.y][position.x + 1] != obstruction {
                newPosition.x += 1
            } else {
                newDirection = .down
            }
    }

    return (newPosition, newDirection)
}


