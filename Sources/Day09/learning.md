1. "inout" parameters

    ```
    func defragmentBlocks(_ blocks: inout [Int?]) {
        ...
    }
    
    var blocks = parseBlocks(from: fileContents)
    defragmentBlocks(&blocks)
    ```
