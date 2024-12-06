import Foundation

let fileURL = URL(fileURLWithPath: "day06_input.txt")
// let fileURL = URL(fileURLWithPath: "day06_test.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
let lines = fileContents.components(separatedBy: "\n")

// cell structure that holds the visited status and the direction in which this cell was visited
struct Cell: Hashable {
    var value: Character
    var direction: Direction?
    var positionX: Int
    var positionY: Int

    init(_ value: Character, _ positionX: Int, _ positionY: Int) {
        self.value = value
        self.direction = nil
        self.positionX = positionX
        self.positionY = positionY
    }
}

var path = [Cell]()

// Directions
enum Direction: Character {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"
}

let obstruction: Character = "#"

// Create matrix from input lines
var matrix = lines.enumerated().map { (i, line) in
    line.enumerated().map { (j, cell) in
        Cell(cell, j, i)
    }
}

let rows = matrix.count
let columns = matrix[0].count
print("Matrix: rows \(rows) columns \(columns)")

var start = (x: 0, y: 0)
var visited: Set<String> = Set<String>()

// find the starting position
if let startPosition = matrix.enumerated().flatMap({ (i, row) in
    row.enumerated().compactMap { (j, cell) in
        ["^", ">", "v", "<"].contains(cell.value) ? (i, j) : nil
    }
}).first {
    start.y = startPosition.0
    start.x = startPosition.1
}

// Part 1
print("Part 1: Initial position: \(start.x),\(start.y), direction: \(matrix[start.y][start.x].value)")
var direction = Direction(rawValue: matrix[start.y][start.x].value)!
// mark the starting cell as visited
visited.insert("\(start.x),\(start.y)")
var startCell = Cell(matrix[start.y][start.x].value, start.x, start.y)
startCell.direction = direction
path.append(startCell)
visited = traverse(position: start, direction: direction, visited: visited)
print("Part 1: \(visited.count)")

// print("Path length: \(path.count):")
// path.forEach { cell in
    // print(cell)
// }
// end Part 1


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
        var cell = Cell(matrix[currentPosition.y][currentPosition.x].value, currentPosition.x, currentPosition.y) 
        cell.direction = currentDirection
        path.append(cell)
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
            if matrix[position.y - 1][position.x].value != obstruction {
                newPosition.y -= 1
            } else {
                newDirection = .right
            }
        case .down:
            if matrix[position.y + 1][position.x].value != obstruction {
                newPosition.y += 1
            } else {
                newDirection = .left
            }
        case .left:
            if matrix[position.y][position.x - 1].value != obstruction {
                newPosition.x -= 1
            } else {
                newDirection = .up
            }
        case .right:
            if matrix[position.y][position.x + 1].value != obstruction {
                newPosition.x += 1
            } else {
                newDirection = .down
            }
    }

    return (newPosition, newDirection)
}


// Part 2
print("Part 2. Initial position: \(start.x),\(start.y), direction: \(direction.rawValue)")
var visitedCells: Set<Cell> = Set<Cell>()
matrix[start.y][start.x].direction = Direction(rawValue: matrix[start.y][start.x].value)!
visitedCells.insert(matrix[start.y][start.x])
var loopCausingCells = Set<String>()

for i in 1..<path.count {
    let cellOnThePath = path[i]
    matrix[cellOnThePath.positionY][cellOnThePath.positionX].value = obstruction
    if traverseAndDetectTheLoop (
        position: start,
        direction: direction,
        visited: visitedCells
    ) {  
        loopCausingCells.insert("\(cellOnThePath.positionX),\(cellOnThePath.positionY)")
    }
    //clear the obstruction
    matrix[cellOnThePath.positionY][cellOnThePath.positionX].value = "."
}
print("Part 2: \(loopCausingCells.count)")



func traverseAndDetectTheLoop(position: (x: Int, y: Int), direction: Direction, visited: Set<Cell>) -> Bool {
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
        matrix[currentPosition.y][currentPosition.x].direction = currentDirection
        
        // if the cell is already visited with the same direction, then we have a loop
        if newVisited.contains(matrix[currentPosition.y][currentPosition.x]) {
            // print("Loop detected at \(currentPosition.x),\(currentPosition.y) with direction \(currentDirection.rawValue)")
            return true
        }


        newVisited.insert(matrix[currentPosition.y][currentPosition.x])
    }

    return false
}