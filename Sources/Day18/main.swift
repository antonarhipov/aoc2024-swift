import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func neighbors() -> [Point] {
        [
            Point(x, y - 1), // up
            Point(x, y + 1), // down
            Point(x - 1, y), // left
            Point(x + 1, y)  // right
        ]
    }
}

func parseInput(_ input: String) -> [(Point, Int)] {
    var bytes: [(Point, Int)] = []  // (point, order)
    let lines = input.components(separatedBy: .newlines)
    var order = 0
    
    for line in lines where !line.isEmpty {
        let coords = line.split(separator: ",").compactMap { Int($0) }
        guard coords.count == 2 else { continue }
        bytes.append((Point(coords[0], coords[1]), order))
        order += 1
    }
    
    return bytes
}

func visualizeGrid(corrupted: Set<Point>, size: Int = 10) {
    print("\nGrid visualization (first \(size)x\(size)):")
    for y in 0..<size {
        var line = ""
        for x in 0..<size {
            let point = Point(x, y)
            if point == Point(0, 0) {
                line += "S"
            } else if corrupted.contains(point) {
                line += "#"
            } else {
                line += "."
            }
        }
        print(line)
    }
    print()
}

func findShortestPath(from start: Point, to end: Point, avoiding corrupted: Set<Point>) -> Int? {
    var visited = Set<Point>()
    var queue: [(Point, Int)] = [(start, 0)] // (point, steps)
    var index = 0
    
    while index < queue.count {
        let (current, steps) = queue[index]
        index += 1
        
        if current == end {
            return steps
        }
        
        for next in current.neighbors() {
            if next.x < 0 || next.x > end.x || next.y < 0 || next.y > end.y {
                continue // Out of bounds
            }
            
            if corrupted.contains(next) || visited.contains(next) {
                continue // Corrupted or already visited
            }
            
            visited.insert(next)
            queue.append((next, steps + 1))
        }
    }
    
    return nil // No path found
}


print("\n=== Part 1 ===")
let input = try String(contentsOfFile: "day18_input.txt", encoding: .utf8)
print("Found \(input.components(separatedBy: .newlines).count) lines")
let bytes: [(point: Point, order: Int)] = parseInput(input)

let firstKilobyte = Set(bytes.prefix(1024).map { $0.point })
if let steps = findShortestPath(from: Point(0, 0), to: Point(70, 70), avoiding: firstKilobyte) {
    print("Minimum steps needed:", steps)
} else {
    print("No path found!")
}

// Part 2: Find first byte that blocks the path
print("\n=== Part 2 ===")
var corrupted = Set<Point>()
var lastPathFound = true

//brute force
for (point, _) in bytes {
    corrupted.insert(point)
    
    if let _ = findShortestPath(from: Point(0, 0), to: Point(70, 70), avoiding: corrupted) {
        lastPathFound = true
    } else {
        if lastPathFound {
            print("\(point.x),\(point.y)")  // Print in exact format required
            break
        }
        lastPathFound = false
    }
}
