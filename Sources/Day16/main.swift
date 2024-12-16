import Foundation

enum Direction: Int {
    case north = 0, east, south, west

    // 0 -> turn(clockwise) -> 1       0 + 1 % 4 = 1
    // 1 -> turn(clockwise) -> 2       1 + 1 % 4 = 2
    // 2 -> turn(clockwise) -> 3       2 + 1 % 4 = 3
    // 3 -> turn(clockwise) -> 0       3 + 1 % 4 = 0
    // 0 -> turn(!clockwise) -> 3      0 + 3 % 4 = 3
    // 3 -> turn(!clockwise) -> 2      3 + 3 % 4 = 2
    // 2 -> turn(!clockwise) -> 1      2 + 3 % 4 = 1
    // 1 -> turn(!clockwise) -> 0      1 + 3 % 4 = 0
    func turn(_ clockwise: Bool) -> Direction {
        let newRawValue = (self.rawValue + (clockwise ? 1 : 3)) % 4
        return Direction(rawValue: newRawValue)!
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

struct Position: Hashable {
    let x: Int
    let y: Int
}

struct PriorityQueue<T> {
    // The queue stores elements of type `T` associated with priority `Int`.
    private var heap: [(priority: Int, item: T)]
    
    // The comparison function for ordering elements in the queue.
    private let order: (Int, Int) -> Bool
    
    
    //   `@escaping` annotation is required because the closure is stored in a property 
    //   and will be called after the initializer completes, escaping the scope of the initializer.
    init(order: @escaping (Int, Int) -> Bool) {
        self.heap = []
        self.order = order
    }
    
    var isEmpty: Bool { heap.isEmpty }
    
    mutating func push(_ item: T, priority: Int) {
        heap.append((priority, item))
        moveUp(from: heap.count - 1)
    }
    
    mutating func pop() -> (T, Int)? {
        guard !heap.isEmpty else { return nil }
        let result = heap[0]
        heap[0] = heap[heap.count - 1]
        heap.removeLast()
        if !heap.isEmpty {
            moveDown(from: 0)
        }
        return (result.item, result.priority)
    }
    
    private mutating func moveUp(from index: Int) {
        var child = index
        var parent = (child - 1) / 2
        while child > 0 && order(heap[child].priority, heap[parent].priority) {
            heap.swapAt(child, parent)
            child = parent
            parent = (child - 1) / 2
        }
    }
    
    private mutating func moveDown(from index: Int) {
        var parent = index
        while true {
            let leftChild = 2 * parent + 1
            let rightChild = leftChild + 1
            var candidate = parent
            
            if leftChild < heap.count && order(heap[leftChild].priority, heap[candidate].priority) {
                candidate = leftChild
            }
            if rightChild < heap.count && order(heap[rightChild].priority, heap[candidate].priority) {
                candidate = rightChild
            }
            if candidate == parent {
                return
            }
            heap.swapAt(parent, candidate)
            parent = candidate
        }
    }
}

func findStartAndEnd(in maze: [[Character]]) -> (start: Position, end: Position) {
    var start: Position?
    var end: Position?
    
    for y in 0..<maze.count {
        for x in 0..<maze[y].count {
            if maze[y][x] == "S" {
                start = Position(x: x, y: y)
            } else if maze[y][x] == "E" {
                end = Position(x: x, y: y)
            }
        }
    }
    
    return (start!, end!)
}

func findOptimalPaths(in maze: [[Character]]) -> (minCost: Int, optimalTiles: Int) {
    let height = maze.count
    let width = maze[0].count
    print("Height:", height, "Width:", width)
    
    let (start, end) = findStartAndEnd(in: maze)
    
    var pq = PriorityQueue<(state: State, path: [Position])> { $0 < $1 }
    var visited = [State: (cost: Int, paths: [[Position]])]()
    var minEndCost = Int.max
    var optimalPaths = Set<Position>()
    
    let startState = State(x: start.x, y: start.y, direction: .east)
    pq.push((state: startState, path: [Position(x: start.x, y: start.y)]), priority: 0)
    visited[startState] = (0, [[Position(x: start.x, y: start.y)]])
    
    while let ((current, path), cost) = pq.pop() {
        if cost > minEndCost { continue }
        
        if current.x == end.x && current.y == end.y {
            if cost < minEndCost {
                minEndCost = cost
                optimalPaths = Set(path)
            } else if cost == minEndCost {
                optimalPaths.formUnion(path)
            }
            continue
        }
        
        if let prevVisit = visited[current], prevVisit.cost < cost { continue }
        
        // Try moving forward
        let nextX = current.x + current.direction.movement.dx
        let nextY = current.y + current.direction.movement.dy
        
        if nextX >= 0 && nextX < width && nextY >= 0 && nextY < height && maze[nextY][nextX] != "#" {
            let nextState = State(x: nextX, y: nextY, direction: current.direction)
            let newCost = cost + 1
            let newPath = path + [Position(x: nextX, y: nextY)]
            
            if visited[nextState]?.cost == nil || visited[nextState]!.cost >= newCost {
                if visited[nextState]?.cost == newCost {
                    visited[nextState]!.paths.append(newPath)
                } else {
                    visited[nextState] = (newCost, [newPath])
                }
                pq.push((state: nextState, path: newPath), priority: newCost)
            }
        }
        
        // Try turning
        for clockwise in [true, false] {
            let nextDirection = current.direction.turn(clockwise)
            let nextState = State(x: current.x, y: current.y, direction: nextDirection)
            let newCost = cost + 1000
            
            if visited[nextState]?.cost == nil || visited[nextState]!.cost >= newCost {
                if visited[nextState]?.cost == newCost {
                    visited[nextState]!.paths.append(path)
                } else {
                    visited[nextState] = (newCost, [path])
                }
                pq.push((state: nextState, path: path), priority: newCost)
            }
        }
    }
    
    return (minEndCost, optimalPaths.count)
}

func printMaze(_ maze: [[Character]], optimalTiles: Set<Position>) {
    for y in 0..<maze.count {
        for x in 0..<maze[0].count {
            if maze[y][x] == "#" {
                print("#", terminator: "")
            } else if optimalTiles.contains(Position(x: x, y: y)) {
                print("O", terminator: "")
            } else {
                print(".", terminator: "")
            }
        }
        print()
    }
}


let test1 = """
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
"""
    
let test2 = """
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
"""
    
print("Test 1:")
let maze1 = test1.split(separator: "\n").map { Array($0) }
let (cost1, tiles1) = findOptimalPaths(in: maze1)
print("Cost:", cost1, "Tiles:", tiles1)

print("\nTest 2:")
let maze2 = test2.split(separator: "\n").map { Array($0) }
let (cost2, tiles2) = findOptimalPaths(in: maze2)
print("Cost:", cost2, "Tiles:", tiles2)

let input = try! String(contentsOfFile: "day16_input.txt", encoding: .utf8)
let maze = input.split(separator: "\n").map { Array($0) }
let (minCost, optimalTiles) = findOptimalPaths(in: maze)
print("\nPart 1 - Minimum cost:", minCost)
print("Part 2 - Number of optimal tiles:", optimalTiles)


// Test 1:
// Cost: 7036 Tiles: 45
// Test 2:
// Cost: 11048 Tiles: 64
// Part 1 - Minimum cost: 102488
// Part 2 - Number of optimal tiles: 559