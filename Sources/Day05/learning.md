1. Compound types a.k.a Tuples
```
(Bool, (Int, Int))
```
https://docs.swift.org/swift-book/documentation/the-swift-programming-language/types/                    


2. Let

```
    if let rule = invalidRule {
        return (false, rule)
    }
```    

```
if let position0 = update.firstIndex(of: rule.0), let position1 = update.firstIndex(of: rule.1) {
   return position0 < position1
}
```            