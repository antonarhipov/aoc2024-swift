import Foundation

let fileURL = URL(fileURLWithPath: "day05_input.txt")
// let fileURL = URL(fileURLWithPath: "day05_test.txt")
let fileContents = try String(contentsOf: fileURL, encoding: .utf8)

let fileParts = fileContents.split(separator: "\n\n").map { String($0) }

let pageOrders = fileParts[0].split(separator: "\n").map { line in
    line.split(separator: "|")
}.map { pair in 
    (Int(pair[0])!, Int(pair[1])!)
}

print("Rules:\n--------------")
pageOrders.forEach { pageOrder in
    print(pageOrder)
}

let pageUpdates = fileParts[1].split(separator: "\n").map { line in
    line.split(separator: ",").map { Int($0)! }
}
print("\nUpdates:\n--------------")    
pageUpdates.forEach { pageUpdate in
    print(pageUpdate)
}

print("Solutions:")

let part1 = pageUpdates.filter { update in 
    validate(update: update).0
}.reduce(0) { total, update in
    let middleIndex = update.count / 2
    return total + update[middleIndex]
}
print("Part 1: \(part1)")

let part2 = pageUpdates.filter { update in 
    !validate(update: update).0
}.map { update in
    var tmpUpdate = update
    var validationResult: (Bool, (Int, Int)) = validate(update: tmpUpdate)

    while(validationResult.0 == false) {
        tmpUpdate.swapAt(validationResult.1.0, validationResult.1.1)
        validationResult = validate(update: tmpUpdate)
    }

    if validationResult.0 {
        let middleIndex = tmpUpdate.count / 2
        return tmpUpdate[middleIndex]
    } else {
        return 0
    }
}.reduce(0, +)
print("Part 2: \(part2)")

func validate(update: [Int]) -> (Bool, (Int, Int)) {
    let invalidRule = pageOrders.compactMap { rule -> (Int, Int)? in
        if let position0 = update.firstIndex(of: rule.0), let position1 = update.firstIndex(of: rule.1), position0 > position1 {
            return (position0, position1)
        }
        return nil
    }.first

    if let invalidRule = invalidRule {
        return (false, invalidRule)
    }
    return (true, (0, 0))
}

func validateSinglePage(page: Int, update: [Int]) -> Bool {
    return pageOrders.filter { $0.0 == page || $0.1 == page }
        .compactMap { rule in
            if let position0 = update.firstIndex(of: rule.0), let position1 = update.firstIndex(of: rule.1) {
                return position0 < position1
            }
            return nil
        }
        .contains(true)
}
