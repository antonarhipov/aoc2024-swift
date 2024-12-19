import Foundation

struct Robot {
    var position: (x: Int, y: Int)
    let velocity: (x: Int, y: Int)
    
    mutating func move(width: Int, height: Int) {
        position.x = (position.x + velocity.x + width) % width
        position.y = (position.y + velocity.y + height) % height
    }
}

// Read input from file
// let input = try! String(contentsOfFile: "day14_test.txt", encoding: .utf8)
let input = try! String(contentsOfFile: "day14_input.txt", encoding: .utf8)

// Parse robots
var robots: [Robot] = []
for line in input.components(separatedBy: .newlines) where !line.isEmpty {
    let parts = line.components(separatedBy: " ")
    let position = parts[0].dropFirst(2).components(separatedBy: ",").map { Int($0)! }
    let velocity = parts[1].dropFirst(2).components(separatedBy: ",").map { Int($0)! }
    robots.append(Robot(
        position: (x: position[0], y: position[1]),
        velocity: (x: velocity[0], y: velocity[1])
    ))
}

let width = 101
let height = 103

// Simulate 100 seconds
for _ in 0..<100 {
    for i in robots.indices {
        robots[i].move(width: width, height: height)
    }
}

// Count robots in each quadrant
let midX = width / 2
let midY = height / 2
var quadrants = [0, 0, 0, 0] // top-left, top-right, bottom-left, bottom-right

for robot in robots {
    if robot.position.x == midX || robot.position.y == midY { continue }
    
    let quadrant: Int
    if robot.position.x < midX {
        quadrant = robot.position.y < midY ? 0 : 2
    } else {
        quadrant = robot.position.y < midY ? 1 : 3
    }
    quadrants[quadrant] += 1
}

let safetyFactor = quadrants.reduce(1, *)
print("Safety factor: \(safetyFactor)")
