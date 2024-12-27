import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

struct Region {
    let type: Character
    var points: Set<Point>
    
    var area: Int {
        points.count
    }
    
    var perimeter: Int {
        var perimeter = 0
        for point in points {
            // Check all 4 sides
            for (dx, dy) in [(0,1), (0,-1), (1,0), (-1,0)] {
                let neighbor = Point(x: point.x + dx, y: point.y + dy)
                if !points.contains(neighbor) {
                    perimeter += 1
                }
            }
        }
        return perimeter
    }
    
    func calculateSides() -> Int {
        // First, find all connected components (regions)
        var visited = Set<Point>()
        var regions: [[Point]] = []
        
        for point in points {
            if !visited.contains(point) {
                var region: [Point] = []
                var queue = [point]
                
                while !queue.isEmpty {
                    let current = queue.removeFirst()
                    if !visited.contains(current) {
                        visited.insert(current)
                        region.append(current)
                        
                        // Add unvisited neighbors
                        for (dx, dy) in [(0,1), (0,-1), (1,0), (-1,0)] {
                            let neighbor = Point(x: current.x + dx, y: current.y + dy)
                            if points.contains(neighbor) && !visited.contains(neighbor) {
                                queue.append(neighbor)
                            }
                        }
                    }
                }
                
                regions.append(region)
            }
        }
        
        // Calculate sides for each region separately
        var totalSides = 0
        
        for region in regions {
            let regionSet = Set(region)
            
            // Find min and max coordinates for this region
            let minX = region.map { $0.x }.min()!
            let maxX = region.map { $0.x }.max()!
            let minY = region.map { $0.y }.min()!
            let maxY = region.map { $0.y }.max()!
            
            // Find edge points in each direction
            var topEdges: [[Point]] = []
            var bottomEdges: [[Point]] = []
            var leftEdges: [[Point]] = []
            var rightEdges: [[Point]] = []
            
            // Find horizontal edges (top and bottom)
            for y in (minY-1)...(maxY+1) {
                var topRow: [Point] = []
                var bottomRow: [Point] = []
                
                for x in minX...maxX {
                    let point = Point(x: x, y: y)
                    let down = Point(x: x, y: y + 1)
                    let up = Point(x: x, y: y - 1)
                    
                    // Top edge: current point is outside, point below is in region
                    if !regionSet.contains(point) && regionSet.contains(down) {
                        topRow.append(point)
                    }
                    
                    // Bottom edge: current point is outside, point above is in region
                    if !regionSet.contains(point) && regionSet.contains(up) {
                        bottomRow.append(point)
                    }
                }
                
                if !topRow.isEmpty { topEdges.append(topRow) }
                if !bottomRow.isEmpty { bottomEdges.append(bottomRow) }
            }
            
            // Find vertical edges (left and right)
            for x in (minX-1)...(maxX+1) {
                var leftCol: [Point] = []
                var rightCol: [Point] = []
                
                for y in minY...maxY {
                    let point = Point(x: x, y: y)
                    let right = Point(x: x + 1, y: y)
                    let left = Point(x: x - 1, y: y)
                    
                    // Left edge: current point is outside, point to right is in region
                    if !regionSet.contains(point) && regionSet.contains(right) {
                        leftCol.append(point)
                    }
                    
                    // Right edge: current point is outside, point to left is in region
                    if !regionSet.contains(point) && regionSet.contains(left) {
                        rightCol.append(point)
                    }
                }
                
                if !leftCol.isEmpty { leftEdges.append(leftCol) }
                if !rightCol.isEmpty { rightEdges.append(rightCol) }
            }
            
            // Count contiguous groups in each direction
            func countContiguousGroups(_ points: [Point]) -> Int {
                if points.isEmpty { return 0 }
                var groups = 0
                var lastPoint: Point? = nil
                
                for point in points.sorted(by: { ($0.x, $0.y) < ($1.x, $1.y) }) {
                    if let last = lastPoint {
                        // If points are not adjacent, start new group
                        if abs(point.x - last.x) > 1 || abs(point.y - last.y) > 1 {
                            groups += 1
                        }
                    } else {
                        groups = 1
                    }
                    lastPoint = point
                }
                
                return groups
            }
            
            // Count sides for this region
            let horizontalTopSegments = topEdges.map { countContiguousGroups($0) }.reduce(0, +)
            let horizontalBottomSegments = bottomEdges.map { countContiguousGroups($0) }.reduce(0, +)
            let verticalLeftSegments = leftEdges.map { countContiguousGroups($0) }.reduce(0, +)
            let verticalRightSegments = rightEdges.map { countContiguousGroups($0) }.reduce(0, +)
            
            totalSides += max(4, horizontalTopSegments + horizontalBottomSegments + verticalLeftSegments + verticalRightSegments)
        }
        
        return totalSides
    }
}

func findRegions(in grid: [[Character]]) -> [Region] {
    let height = grid.count
    let width = grid[0].count
    var visited = Set<Point>()
    var regions: [Region] = []
    
    func bfs(startPoint: Point, type: Character) -> Set<Point> {
        var points = Set<Point>()
        var queue = [startPoint]
        
        while !queue.isEmpty {
            let point = queue.removeFirst()
            guard !points.contains(point) else { continue }
            points.insert(point)
            
            // Check all 4 directions
            for (dx, dy) in [(0,1), (0,-1), (1,0), (-1,0)] {
                let newX = point.x + dx
                let newY = point.y + dy
                
                guard newX >= 0 && newX < width && newY >= 0 && newY < height else { continue }
                let newPoint = Point(x: newX, y: newY)
                
                if grid[newY][newX] == type && !points.contains(newPoint) {
                    queue.append(newPoint)
                }
            }
        }
        
        return points
    }
    
    // Find all regions
    for y in 0..<height {
        for x in 0..<width {
            let point = Point(x: x, y: y)
            if !visited.contains(point) {
                let type = grid[y][x]
                let regionPoints = bfs(startPoint: point, type: type)
                visited.formUnion(regionPoints)
                regions.append(Region(type: type, points: regionPoints))
            }
        }
    }
    
    return regions
}

// let input = try String(contentsOfFile: "day12_test.txt", encoding: .utf8)
let input = try String(contentsOfFile: "day12_input.txt", encoding: .utf8)
let grid = input.split(separator: "\n").map { Array($0) }

let regions = findRegions(in: grid)

// Part 1
var total = 0
for region in regions {
    total += region.area * region.perimeter
}
print("Part 1:", total)

// Part 2
total = 0
for region in regions {
    total += region.area * region.calculateSides()
}
print("Part 2:", total)
