import Foundation

// Read input from file
// func readInput() -> String {
//     let filePath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "day23.txt"
//     let currentDirectoryPath = FileManager.default.currentDirectoryPath
//     let fileURL = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(filePath)
    
//     guard let input = try? String(contentsOfFile: fileURL.path, encoding: .utf8) else {
//         fatalError("Could not read input file \(filePath)")
//     }
    
//     return input
// }

// Parse input and build graph
func buildGraph(from input: String) -> [String: Set<String>] {
    var graph: [String: Set<String>] = [:]
    
    let connections = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
    for connection in connections {
        let computers = connection.components(separatedBy: "-")
        let comp1 = computers[0]
        let comp2 = computers[1]
        
        graph[comp1, default: []].insert(comp2)
        graph[comp2, default: []].insert(comp1)
    }
    
    return graph
}

// Find all sets of three interconnected computers
func findTriples(in graph: [String: Set<String>]) -> Set<Set<String>> {
    var triples = Set<Set<String>>()
    let computers = Array(graph.keys)
    
    for i in 0..<computers.count {
        let comp1 = computers[i]
        let neighbors1 = graph[comp1] ?? []
        
        for comp2 in neighbors1 where comp2 > comp1 {
            let neighbors2 = graph[comp2] ?? []
            
            for comp3 in neighbors2 where comp3 > comp2 {
                // Check if comp1 and comp3 are also connected
                if neighbors1.contains(comp3) {
                    triples.insert([comp1, comp2, comp3])
                }
            }
        }
    }
    
    return triples
}

// Count triples containing computer with name starting with 't'
func countTriplesWithT(_ triples: Set<Set<String>>) -> Int {
    triples.filter { triple in
        triple.contains { $0.hasPrefix("t") }
    }.count
}

// Test input
let testInput = """
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
"""

// Process test input
let testGraph = buildGraph(from: testInput)
let testTriples = findTriples(in: testGraph)
let testResult = countTriplesWithT(testTriples)
print("\n=== Part 1 ===")
print("Test result:", testResult)
assert(testResult == 7, "Test failed: expected 7 but got \(testResult)")
let input = try String(contentsOfFile: "day23_input.txt", encoding: .utf8)
print("Found \(input.components(separatedBy: .newlines).count) lines")



// Process real input
// let input = readInput()
let graph = buildGraph(from: input)
let triples = findTriples(in: graph)
let result = countTriplesWithT(triples)
print("Result:", result)
