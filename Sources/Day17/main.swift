import Foundation

// Part 1
let input = try parseInput(from: "day17_input.txt")
var computer = Computer(registerA: input.registerA, 
                        registerB: input.registerB, 
                        registerC: input.registerC, 
                        program: input.program)
computer.run()
let result = computer.output.map { String($0) }.joined(separator: ",")
print("A: \(result)")

    
// Part 2
print("\nSearching for lowest valid A...")
print(decode(nextA: 0, left: input.program.count - 1))

func decode(nextA: Int, left: Int) -> Int {
    if left < 0 { return nextA }
    for i in 0...7 {
        let a = nextA * 8 + i
        
        var c = Computer(registerA: a, 
                            registerB: input.registerB, 
                            registerC: input.registerC, 
                            program: input.program)
        c.run()
        
        if c.output == Array(input.program[left...]) {
            let result = decode(nextA: a, left: left - 1)
            if result != 0 { return result }
        }
    }
    return 0
}


struct Computer {
    var registerA: Int
    var registerB: Int
    var registerC: Int
    var instructionPointer: Int = 0
    var program: [Int]
    var output: [Int] = []
    
    init(registerA: Int, registerB: Int, registerC: Int, program: [Int]) {
        self.registerA = registerA
        self.registerB = registerB
        self.registerC = registerC
        self.program = program
    }
    
    func getComboValue(_ operand: Int) -> Int {
        switch operand {
            case 0...3: return operand
            case 4: return registerA
            case 5: return registerB
            case 6: return registerC
            default: fatalError("Invalid combo operand: \(operand)")
        }
    }
    
    mutating func run() {
        while instructionPointer < program.count - 1 {
            let opcode = program[instructionPointer]
            let operand = program[instructionPointer + 1]
            
            switch opcode {
                case 0: // adv
                    registerA = registerA / Int(pow(2.0, Double(getComboValue(operand))))
                case 1: // bxl
                    registerB = registerB ^ operand
                case 2: // bst
                    registerB = getComboValue(operand) % 8
                case 3: // jnz
                    if registerA != 0 {
                        instructionPointer = operand
                        continue
                    }
                case 4: // bxc
                    registerB = registerB ^ registerC
                case 5: // out
                    output.append(getComboValue(operand) % 8)
                case 6: // bdv
                    registerB = registerA / Int(pow(2.0, Double(getComboValue(operand))))
                case 7: // cdv
                    registerC = registerA / Int(pow(2.0, Double(getComboValue(operand))))
                default:
                    fatalError("Invalid opcode: \(opcode)")
            }
            
            instructionPointer += 2
        }
    }

    func outputMatchesProgram() -> Bool {
        guard output.count == program.count else { return false }
        return output == program
    }
}

// Parse input file
func parseInput(from path: String) throws -> (registerA: Int, registerB: Int, registerC: Int, program: [Int]) {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let lines = contents.components(separatedBy: .newlines)
    
    var registerA = 0, registerB = 0, registerC = 0
    var program: [Int] = []
    
    for line in lines {
        if line.starts(with: "Register A:") {
            registerA = Int(line.split(separator: ":")[1].trimmingCharacters(in: .whitespaces))!
        } else if line.starts(with: "Register B:") {
            registerB = Int(line.split(separator: ":")[1].trimmingCharacters(in: .whitespaces))!
        } else if line.starts(with: "Register C:") {
            registerC = Int(line.split(separator: ":")[1].trimmingCharacters(in: .whitespaces))!
        } else if line.starts(with: "Program:") {
            program = line.split(separator: ":")[1]
                .trimmingCharacters(in: .whitespaces)
                .split(separator: ",")
                .map { Int($0.trimmingCharacters(in: .whitespaces))! }
        }
    }
    
    return (registerA, registerB, registerC, program)
}

func findLowestValidA(registerB: Int, registerC: Int, program: [Int]) -> Int {
    // Binary search approach since the value might be large
    var attempts = 0
    
    print("Program to match:", program.map { String($0) }.joined(separator: ","))
    
    for a in 0..<Int.max {
        attempts += 1
        if attempts % 100_000 == 0 {
            print("Tried \(attempts) values, current A: \(a)")
        }
        
        var computer = Computer(registerA: a, registerB: registerB, registerC: registerC, program: program)
        computer.run()
        
        if computer.outputMatchesProgram() {
            print("\nFound matching output for A = \(a)")
            print("Output:", computer.output.map(String.init).joined(separator: ","))
            return a
        }
    }
    
    return -1
}
