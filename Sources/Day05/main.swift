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



// Part 1
print("\nPart1: \(part1())")

func part1() -> Int {
    var total = 0
    for update in pageUpdates {
        print(update)
        var valid = true

        for page in update {
            print("Page: \(page)", terminator: " ")
            let matchingRules = pageOrders.filter { rule in
                rule.0 == page || rule.1 == page
            }

            print("Matching Rules: \(matchingRules)")
            for rule in matchingRules {
                let position0 = update.firstIndex(of: rule.0)
                let position1 = update.firstIndex(of: rule.1)
                
                print("Rule \(rule) is", terminator: " ")
                if(position0 != nil && position1 != nil) {
                    if position0! < position1! {
                        print("valid: The position of \(rule.0) at \(position0!) comes before \(rule.1) at \(position1!)")
                    } else {
                        print("NOT valid: The position of \(rule.0) at \(position0!) comes after \(rule.1) at \(position1!)")
                        valid = false
                    }
                } else {
                    print("is not applicable: One of the pages is not in the update list")
                }

            }
        }

        if valid {
            // find middle index in the update
            let middleIndex = update.count / 2
            total += update[middleIndex]
        }

        print("Update \(update) is \(valid ? "valid" : "NOT valid")")
    }
    return total
}







