import Foundation

enum Direction: CaseIterable {
    case north, east, south, west
    
    func turn(_ clockwise: Bool) -> Direction {
        switch (self, clockwise) {
            case (.north, true): return .east
            case (.east, true): return .south
            case (.south, true): return .west
            case (.west, true): return .north
            case (.north, false): return .west
            case (.east, false): return .north
            case (.south, false): return .east
            case (.west, false): return .south
        }
    }
    
    var movement: (dx: Int, dy: Int) {
        switch self {
            case .north: return (0, -1)
            case .south: return (0, 1)
            case .east: return (1, 0)
            case .west: return (-1, 0)
        }
    }
}

struct State: Hashable {
    let x: Int
    let y: Int
    let direction: Direction
}

struct PriorityQueueElement: Comparable {
    let state: State
    let cost: Int
    
    static func < (lhs: PriorityQueueElement, rhs: PriorityQueueElement) -> Bool {
        lhs.cost < rhs.cost
    }
}

func findShortestPath(in maze: [[Character]]) -> Int {
    let height = maze.count
    let width = maze[0].count
    
    var start: (x: Int, y: Int)?
    var end: (x: Int, y: Int)?
    
    // Find start and end positions
    for y in 0..<height {
        for x in 0..<width {
            if maze[y][x] == "S" { start = (x, y) }
            if maze[y][x] == "E" { end = (x, y) }
        }
    }
    
    guard let start = start, let end = end else { return -1 }
    
    var priorityQueue = [PriorityQueueElement(state: State(x: start.x, y: start.y, direction: .east), cost: 0)]
    var visited = Set<State>()
    
    while !priorityQueue.isEmpty {
        priorityQueue.sort()  // Keep queue sorted by cost
        let current = priorityQueue.removeFirst()
        
        if current.state.x == end.x && current.state.y == end.y {
            return current.cost
        }
        
        if visited.contains(current.state) {
            continue
        }
        visited.insert(current.state)
        
        // Try moving forward
        let nextX = current.state.x + current.state.direction.movement.dx
        let nextY = current.state.y + current.state.direction.movement.dy
        
        if nextX >= 0 && nextX < width && nextY >= 0 && nextY < height && maze[nextY][nextX] != "#" {
            let nextState = State(x: nextX, y: nextY, direction: current.state.direction)
            if !visited.contains(nextState) {
                priorityQueue.append(PriorityQueueElement(state: nextState, cost: current.cost + 1))
            }
        }
        
        // Try turning clockwise and counterclockwise
        for clockwise in [true, false] {
            let nextDirection = current.state.direction.turn(clockwise)
            let nextState = State(x: current.state.x, y: current.state.y, direction: nextDirection)
            if !visited.contains(nextState) {
                priorityQueue.append(PriorityQueueElement(state: nextState, cost: current.cost + 1000))
            }
        }
    }
    
    return -1
}


let input = try! String(contentsOfFile: "day16_input.txt", encoding: .utf8)
let maze = input.split(separator: "\n").map { Array($0) }
let result = findShortestPath(in: maze)
print("Result:", result)
