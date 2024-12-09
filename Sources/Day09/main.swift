import Foundation

func readFileContents(from fileName: String) throws -> String {
    let fileURL = URL(fileURLWithPath: fileName)
    return try String(contentsOf: fileURL, encoding: .utf8)
}

func parseBlocks(from fileContents: String) -> [Int?] {
    return fileContents.enumerated().flatMap { (index, char) -> [Int?] in
        let length = Int(String(char))!
        if index % 2 == 0 {
            let fileId = index / 2
            return Array(repeating: fileId, count: length)
        } else {
            return Array(repeating: nil, count: length)
        }
    }
}

func defragmentBlocks(_ blocks: inout [Int?]) {
    var position = 0
    while position < blocks.count {
        if blocks[position] == nil {
            var foundFile = false
            for i in (position + 1..<blocks.count).reversed() {
                if let fileId = blocks[i] {
                    blocks[position] = fileId
                    blocks[i] = nil
                    foundFile = true
                    break
                }
            }
            if !foundFile {
                break
            }
        }
        position += 1
    }
}

func calculateChecksum(from blocks: [Int?]) -> Int {
    return blocks.enumerated().reduce(0) { (sum, element) in
        let (position, block) = element
        if let fileId = block {
            return sum + position * fileId
        }
        return sum
    }
}

let fileContents = try readFileContents(from: "day09_input.txt")
var blocks = parseBlocks(from: fileContents)
defragmentBlocks(&blocks)
let checksum = calculateChecksum(from: blocks)
print("Part 1: \(checksum)")
