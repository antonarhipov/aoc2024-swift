import Foundation

struct ClawMachine {
    let buttonA: (x: Int, y: Int)
    let buttonB: (x: Int, y: Int)
    let prize: (x: Int, y: Int)
    
    // Returns the minimum tokens needed to win the prize, or nil if impossible
    func minimumTokensToWin(part2: Bool = false) -> Int? {
        let targetX = part2 ? prize.x + 10_000_000_000_000 : prize.x
        let targetY = part2 ? prize.y + 10_000_000_000_000 : prize.y
        
        // Try combinations of A and B presses up to 100 times each
        for a in 0...100 {
            for b in 0...100 {
                let x = a * buttonA.x + b * buttonB.x
                let y = a * buttonA.y + b * buttonB.y
                
                if x == targetX && y == targetY {
                    // Found a solution! Calculate tokens needed
                    return a * 3 + b
                }
            }
        }
        return nil
    }
}

func parseInput(_ input: String) -> [ClawMachine] {
    let machines = input.components(separatedBy: "\n\n")
    return machines.map { machine in
        let lines = machine.components(separatedBy: .newlines)
        
        // Parse Button A
        let aComponents = lines[0].components(separatedBy: ", ")
        let aX = Int(aComponents[0].split(separator: "+")[1])!
        let aY = Int(aComponents[1].split(separator: "+")[1])!
        
        // Parse Button B
        let bComponents = lines[1].components(separatedBy: ", ")
        let bX = Int(bComponents[0].split(separator: "+")[1])!
        let bY = Int(bComponents[1].split(separator: "+")[1])!
        
        // Parse Prize
        let prizeComponents = lines[2].components(separatedBy: ", ")
        let prizeX = Int(prizeComponents[0].split(separator: "=")[1])!
        let prizeY = Int(prizeComponents[1].split(separator: "=")[1])!
        
        return ClawMachine(
            buttonA: (aX, aY),
            buttonB: (bX, bY),
            prize: (prizeX, prizeY)
        )
    }
}

func solve(_ input: String, part2: Bool = false) -> Int {
    let machines = parseInput(input)
    var totalTokens = 0
    var winnable = 0
    
    for (index, machine) in machines.enumerated() {
        if let tokens = machine.minimumTokensToWin(part2: part2) {
            totalTokens += tokens
            winnable += 1
            print("Machine \(index + 1) is winnable with \(tokens) tokens")
        }
    }
    print("Total winnable machines: \(winnable)")
    return totalTokens
}

// Read input from file
let input = try! String(contentsOfFile: "day13_test.txt", encoding: .utf8)
// let input = try! String(contentsOfFile: "day13_input.txt", encoding: .utf8)

print("Part 1 result:", solve(input))
