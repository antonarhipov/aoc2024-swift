1. "where"-guard

if ... where


In for loop:

```
let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

for number in numbers where number % 2 == 0 {
    print(number) // 0, 2, 4, 6, 8, 10
}
```

https://www.avanderlee.com/swift/where-using-swift/