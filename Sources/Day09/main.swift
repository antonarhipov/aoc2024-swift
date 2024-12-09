import Foundation
import RegexBuilder

// let fileURL = URL(fileURLWithPath: "day09_test.txt")
let fileURL = URL(fileURLWithPath: "day09_input.txt")

protocol Block {}

struct File: Block {
    var id: Int
    var value: Int
}

struct FreeSpace: Block {
    var value: Int
}

let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
print(fileContents)
print("--------------------")
let numbers = Array(fileContents).compactMap { Int(String($0)) }

print("Part 1 in progress...")

var space = numbers.enumerated().map { (offset, element) in
    offset % 2 == 0 ? File(id: offset / 2, value: element) as Block : FreeSpace(value: element) as Block
}.flatMap { block -> [String] in
    if let file = block as? File {
        return Array(repeating: "\(file.id)", count: file.value)
    } else if let freeSpace = block as? FreeSpace {
        return Array(repeating: ".", count: freeSpace.value)
    }
    return []
}.joined()

print("Mapping complete: \(space.count)")

var counter = 0
var dotIndices = space.indices.filter { space[$0] == "." }
var numberIndices = space.indices.filter { space[$0].isNumber }

print("Defragmenting...")
while !validateSpace(space) {
    let firstDot = dotIndices.removeFirst()
    let lastNumber = numberIndices.removeLast()
    let c = space[lastNumber]
    
    space.replaceSubrange(firstDot...firstDot, with: [c])
    space.replaceSubrange(lastNumber...lastNumber, with: ["."])
    
    counter += 1
    if counter % 1000 == 0 {
        print(".")
    }
}

print("Calculating checksum...")
let checksum = space.enumerated().reduce(0) { result, element in
    let (index, value) = element
    if value == "." {
        return result
    }
    let x = index * Int(String(value))!
    print("Calculating: [\(result)] + \(index) * \(value) = \(result + x)")
    return result + x
}
print("Part 1: \(checksum)") // FIXME: This is not the correct answer (works for test input)

func validateSpace(_ space: String) -> Bool {
    var foundDot = false
    for char in space {
        if char == "." {
            foundDot = true
        } else if foundDot && char.isNumber {
            return false
        }
    }
    return foundDot
}