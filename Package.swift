// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "aoc2024",
    platforms: [
        .macOS(.v13),        
    ],
    //dependencies
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // .executableTarget(
            // name: "aoc2024"),
        .executableTarget(
            name: "Learning",
            path: "Sources/Learning"),   
        .executableTarget(
            name: "Day01",
            path: "Sources/Day01"),
        .executableTarget(
            name: "Day02",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "Sources/Day02"),            
        .executableTarget(
            name: "Day03",            
            path: "Sources/Day03",
            swiftSettings: [.enableUpcomingFeature("BareSlashRegexLiterals")]
        ),
        .executableTarget(
            name: "Day04",
            path: "Sources/Day04"),          
        .executableTarget(
            name: "Day05",
            path: "Sources/Day05"),              
        .executableTarget(
            name: "Day06",
            path: "Sources/Day06"),
        .executableTarget(
            name: "Day07",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "Sources/Day07"),
        .executableTarget(
            name: "Day08",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "Sources/Day08"),    
        .executableTarget(
            name: "Day09",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "Sources/Day09"),
        .executableTarget(
            name: "Day10",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "Sources/Day10"),    
    ]
)
