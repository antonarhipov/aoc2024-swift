import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
    
    func neighbors() -> [Point] {
        return [
            Point(x: x, y: y - 1),
            Point(x: x, y: y + 1),
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y)
        ]
    }
    
    func manhattanDistance(to other: Point) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
}

struct Maze {
    let grid: [[Bool]]  // true = wall
    let start: Point
    let end: Point
    let width: Int
    let height: Int
    var pathCache: [String: Int] = [:]
    
    init(input: String) {
        let lines = input.split(separator: "\n").map { Array($0) }
        height = lines.count
        width = lines[0].count
        
        var startPoint = Point(x: 0, y: 0)
        var endPoint = Point(x: 0, y: 0)
        grid = lines.enumerated().map { y, row in
            row.enumerated().map { x, char in
                if char == "S" { startPoint = Point(x: x, y: y) }
                if char == "E" { endPoint = Point(x: x, y: y) }
                return char == "#"
            }
        }
        
        start = startPoint
        end = endPoint
    }
    
    func isWall(_ p: Point) -> Bool {
        guard p.y >= 0 && p.y < height && p.x >= 0 && p.x < width else { return true }
        return grid[p.y][p.x]
    }
    
    mutating func shortestPath(from: Point, to: Point) -> Int? {
        let cacheKey = "\(from.x),\(from.y)-\(to.x),\(to.y)"
        if let cached = pathCache[cacheKey] {
            return cached
        }
        
        var visited = Set<Point>()
        var queue = [(from, 0)]
        var queueIndex = 0
        
        while queueIndex < queue.count {
            let (current, steps) = queue[queueIndex]
            queueIndex += 1
            
            if current == to {
                pathCache[cacheKey] = steps
                return steps
            }
            
            for next in current.neighbors() {
                if isWall(next) || visited.contains(next) {
                    continue
                }
                visited.insert(next)
                queue.append((next, steps + 1))
            }
        }
        
        return nil
    }
}

func findCheats(in maze: Maze, maxCheatSteps: Int, nearWallsOnly: Bool = false) -> [(savings: Int, cheatStart: Point, cheatEnd: Point)] {
    var maze = maze
    var cheats: [(savings: Int, cheatStart: Point, cheatEnd: Point)] = []
    let normalPath = maze.shortestPath(from: maze.start, to: maze.end) ?? Int.max
    
    var potentialPoints = Set<Point>()
    for y in 0..<maze.height {
        for x in 0..<maze.width {
            let point = Point(x: x, y: y)
            if maze.isWall(point) { continue }
            if !nearWallsOnly || point.neighbors().contains(where: { maze.isWall($0) }) {
                potentialPoints.insert(point)
            }
        }
    }
    
    for start in potentialPoints {
        guard let pathToStart = maze.shortestPath(from: maze.start, to: start) else { continue }
        
        for end in potentialPoints {
            let cheatDistance = start.manhattanDistance(to: end)
            if cheatDistance > maxCheatSteps { continue }
            
            guard let pathFromEnd = maze.shortestPath(from: end, to: maze.end) else { continue }
            
            let totalTime = pathToStart + cheatDistance + pathFromEnd
            let savings = normalPath - totalTime
            
            if savings > 0 {
                cheats.append((savings: savings, cheatStart: start, cheatEnd: end))
            }
        }
    }
    
    return cheats
}

// Test data
let testInput = """
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
"""

// Validate with test data
let testMaze = Maze(input: testInput)
let testCheats1 = findCheats(in: testMaze, maxCheatSteps: 2, nearWallsOnly: true)
let testCheats2 = findCheats(in: testMaze, maxCheatSteps: 20)

print("=== Test Results ===")
print("Part 1: \(testCheats1.filter { $0.savings >= 0 }.count) total cheats")
print("Part 2: \(testCheats2.filter { $0.savings >= 50 }.count) cheats saving ≥50 picoseconds")

// Process actual input
let input = try String(contentsOfFile: "day20_input.txt", encoding: .utf8)
let actualMaze = Maze(input: input.trimmingCharacters(in: .whitespacesAndNewlines))

// Part 1: Find cheats that save ≥100 picoseconds with max 2 steps
let actualCheats1 = findCheats(in: actualMaze, maxCheatSteps: 2, nearWallsOnly: true)
let part1Answer = actualCheats1.filter { $0.savings >= 100 }.count

// Part 2: Find cheats that save ≥100 picoseconds with max 20 steps
let actualCheats2 = findCheats(in: actualMaze, maxCheatSteps: 20)
let part2Answer = actualCheats2.filter { $0.savings >= 100 }.count

print("\n=== Answers ===")
print("Part 1: \(part1Answer)")
print("Part 2: \(part2Answer)")
