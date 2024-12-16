import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

struct Region {
    let points: Set<Point>
    let type: Character
    
    var area: Int {
        points.count
    }
    
    var perimeter: Int {
        var result = 0
        for point in points {
            // Check all 4 sides of each point
            let neighbors = [
                Point(x: point.x + 1, y: point.y),
                Point(x: point.x - 1, y: point.y),
                Point(x: point.x, y: point.y + 1),
                Point(x: point.x, y: point.y - 1)
            ]
            
            // Each side that's not connected to another point in the region adds to perimeter
            for neighbor in neighbors {
                if !points.contains(neighbor) {
                    result += 1
                }
            }
        }
        return result
    }
    
    var price: Int {
        area * perimeter
    }
    
    func debug() -> String {
        "Region \(type): area=\(area), perimeter=\(perimeter), price=\(price)"
    }
}

func findRegions(in grid: [[Character]]) -> [Region] {
    let height = grid.count
    let width = grid[0].count
    var visited = Set<Point>()
    var regions: [Region] = []
    
    func bfs(start: Point, type: Character) -> Set<Point> {
        var points = Set<Point>()
        var queue = [start]
        
        while !queue.isEmpty {
            let point = queue.removeFirst()
            guard !points.contains(point) else { continue }
            points.insert(point)
            
            let neighbors = [
                Point(x: point.x + 1, y: point.y),
                Point(x: point.x - 1, y: point.y),
                Point(x: point.x, y: point.y + 1),
                Point(x: point.x, y: point.y - 1)
            ]
            
            for neighbor in neighbors {
                guard neighbor.x >= 0 && neighbor.x < width &&
                      neighbor.y >= 0 && neighbor.y < height &&
                      grid[neighbor.y][neighbor.x] == type &&
                      !points.contains(neighbor) else { continue }
                queue.append(neighbor)
            }
        }
        
        return points
    }
    
    for y in 0..<height {
        for x in 0..<width {
            let point = Point(x: x, y: y)
            if !visited.contains(point) {
                let type = grid[y][x]
                let regionPoints = bfs(start: point, type: type)
                visited.formUnion(regionPoints)
                regions.append(Region(points: regionPoints, type: type))
            }
        }
    }
    
    return regions
}

func solve(_ input: String) -> Int {
    let grid = input.split(separator: "\n").map { Array($0) }
    let regions = findRegions(in: grid)
    
    // Debug output
    print("Grid size: \(grid[0].count)x\(grid.count)")
    for region in regions {
        print(region.debug())
    }
    
    return regions.reduce(0) { $0 + $1.price }
}

// First test with example
let testInput = try String(contentsOfFile: "day12_test.txt", encoding: .utf8)
print("\nTesting with example:")
let testResult = solve(testInput)
print("Test result:", testResult)
print("\nSolving with actual input:")
let input = try String(contentsOfFile: "day12_input.txt", encoding: .utf8)
let result = solve(input)
print("Result:", result)
