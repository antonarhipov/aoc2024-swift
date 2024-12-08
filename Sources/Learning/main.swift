import Foundation

enum MyErrror: Error {
    case invalidInput
    case invalidOutput
}

func functionThatThrows() throws -> Int {

    let random = Int.random(in: 0...10)
    if random < 10 {
        throw MyErrror.invalidOutput
    }
    return random
}



if let number = try? functionThatThrows() {
    print("Number: \(number)")
} else {
    print("Error")
}



