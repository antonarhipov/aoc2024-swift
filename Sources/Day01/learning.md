1. An interesting way to read file from a URL into a String:

```
String(contentsOf: fileURL, encoding: .utf8)
```

2. For loops don't use braces:

```
for line in lines
```

3. Constructors for primitives seem to be pretty commong:

```
Int($0)          // creates an integer with an argument
Double("22.1")   // creates a double 22.1
Int(22.1)        // creates an integer 22
```

4. Binding to optional value

```
let result = Int($0)  // creates an optional result, Int?, i.e. the result might be 'nil'
let result = Int($0)! // defintely creates a result
```


5. Unusual 'in' syntax for lambdas, and $0

```
let counters = leftcolumn.map { 
    number in   // in Kotlin, we would use an arrow instead
    number * rightcolumn.filter { $0 == number }.count  // in Kotlin, we would use 'it' instead
}
```