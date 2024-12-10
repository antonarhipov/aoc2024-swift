import Foundation

// A point in the grid
struct Point: Hashable {
    let x: Int
    let y: Int
    
    func neighbors() -> [Point] {
        [
            Point(x: x + 1, y: y),
            Point(x: x - 1, y: y),
            Point(x: x, y: y + 1),
            Point(x: x, y: y - 1)
        ]
    }
}

// Read and parse input
// let fileURL = URL(fileURLWithPath: "day10_test.txt")
let fileURL = URL(fileURLWithPath: "day10_input.txt")
let input = try String(contentsOf: fileURL, encoding: .utf8)


// Parse the grid
let grid = input.split(separator: "\n").map { Array($0).map { Int(String($0))! } }
let height = grid.count
let width = grid[0].count
print("Grid size: \(width)x\(height)")

// Find all trailheads (positions with height 0)
var trailheads: [Point] = []
for y in 0..<height {
    for x in 0..<width {
        if grid[y][x] == 0 {
            trailheads.append(Point(x: x, y: y))
        }
    }
}

// Calculate total score
let totalScore = trailheads.map { scoreForTrailhead($0) }.reduce(0, +)
print("Total score: \(totalScore)")

// Calculate total rating
let totalRating = trailheads.map { ratingForTrailhead($0) }.reduce(0, +)
print("Total rating: \(totalRating)")


// Calculate score for a single trailhead
func scoreForTrailhead(_ start: Point) -> Int {
    var reachablePeaks = Set<Point>()
    var visited = Set<Point>()
    var queue = [(point: start, height: 0)]
    visited.insert(start)
    
    while !queue.isEmpty {
        let current = queue.removeFirst()
        
        // If we reached a peak, add it to reachablePeaks
        if grid[current.point.y][current.point.x] == 9 {
            reachablePeaks.insert(current.point)
            continue
        }
        
        // Check all neighbors
        for next in current.point.neighbors() {
            // Skip if out of bounds
            guard next.y >= 0 && next.y < height && next.x >= 0 && next.x < width else { continue }
            // Skip if already visited
            guard !visited.contains(next) else { continue }
            // Skip if height difference is not exactly 1
            let nextHeight = grid[next.y][next.x]
            guard nextHeight == current.height + 1 else { continue }
            
            visited.insert(next)
            queue.append((next, nextHeight))
        }
    }
    
    return reachablePeaks.count
}

// Calculate rating for a single trailhead (number of distinct paths to peaks)
func ratingForTrailhead(_ start: Point) -> Int {
    // Use dynamic programming to count paths
    // dp[y][x] stores the number of paths to this point
    var dp = Array(repeating: Array(repeating: 0, count: width), count: height)
    dp[start.y][start.x] = 1
    
    // Process points by increasing height (0 to 9)
    for h in 0...9 {
        for y in 0..<height {
            for x in 0..<width where grid[y][x] == h && dp[y][x] > 0 {
                let current = Point(x: x, y: y)
                for next in current.neighbors() where next.y >= 0 && next.y < height && next.x >= 0 && next.x < width && grid[next.y][next.x] == h + 1 {
                    dp[next.y][next.x] += dp[y][x]
                }
            }
        }
    }
    
    // Sum up paths to all peaks (height 9)
    var totalPaths = 0
    for y in 0..<height {
        for x in 0..<width {
            if grid[y][x] == 9 {
                totalPaths += dp[y][x]
            }
        }
    }
    
    return totalPaths
}


