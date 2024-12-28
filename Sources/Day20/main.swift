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

func findCheats(in maze: Maze) -> [(savings: Int, cheatStart: Point, cheatEnd: Point)] {
    var maze = maze  // Make maze mutable for caching
    var cheats: [(savings: Int, cheatStart: Point, cheatEnd: Point)] = []
    let normalPath = maze.shortestPath(from: maze.start, to: maze.end) ?? Int.max
    
    // Only consider points that are near walls as potential cheat points
    var potentialPoints = Set<Point>()
    for y in 0..<maze.height {
        for x in 0..<maze.width {
            let point = Point(x: x, y: y)
            if maze.isWall(point) { continue }
            
            // Check if point is adjacent to a wall
            if point.neighbors().contains(where: { maze.isWall($0) }) {
                potentialPoints.insert(point)
            }
        }
    }
    
    for start in potentialPoints {
        // Skip if we can't reach the start point
        guard let pathToStart = maze.shortestPath(from: maze.start, to: start) else { continue }
        
        // Only consider end points that are within 2 steps of start
        for end in potentialPoints {
            let cheatDistance = start.manhattanDistance(to: end)
            if cheatDistance > 2 { continue }
            
            // Skip if we can't reach the maze end from this point
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

let maze = Maze(input: testInput)
let cheats = findCheats(in: maze)

var savingsCount: [Int: Int] = [:]
for cheat in cheats {
    savingsCount[cheat.savings, default: 0] += 1
}

print("Test results:")
let sortedSavings = savingsCount.sorted { $0.key < $1.key }
for (savings, count) in sortedSavings {
    print("There \(count == 1 ? "is" : "are") \(count) cheat\(count == 1 ? "" : "s") that save\(count == 1 ? "s" : "") \(savings) picoseconds.")
}

let cheatsOver100 = cheats.filter { $0.savings >= 100 }.count
print("\nNumber of cheats saving at least 100 picoseconds: \(cheatsOver100)")

// Comment out actual input processing for now

let input = try String(contentsOfFile: "day20_input.txt", encoding: .utf8)
let actualMaze = Maze(input: input.trimmingCharacters(in: .whitespacesAndNewlines))
let actualCheats = findCheats(in: actualMaze)
let actualCheatsOver100 = actualCheats.filter { $0.savings >= 100 }.count
print("\nActual result:")
print("Number of cheats saving at least 100 picoseconds: \(actualCheatsOver100)")

