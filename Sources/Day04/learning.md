1. Guard Statements

https://docs.swift.org/swift-book/documentation/the-swift-programming-language/statements/#Guard-Statement

With guard:
```
    guard newRow >= 0, newRow < rows, newCol >= 0, newCol < columns else { return nil }
```

Alternative with if-expression:
```
    if !(newRow >= 0 && newRow < rows && newCol >= 0 && newCol < columns) { return nil }
```
                    