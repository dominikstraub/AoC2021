// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AoC2021",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Utils",
            dependencies: []
        ),
        // .executableTarget(
        //     name: "Day01",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day02",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day03",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day04",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day05",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day06",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day07",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day08",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day09",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day10",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day11",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day12",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day13",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day14",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        .executableTarget(
            name: "Day15",
            dependencies: ["Utils"],
            resources: [
                .process("input.txt"),
                .process("test.txt"),
                .process("test2.txt"),
            ]
        ),
        // .executableTarget(
        //     name: "Day16",
        //     dependencies: ["Utils"],
        //     resources: [
        //         .process("input.txt"),
        //         .process("test.txt"),
        //         .process("test2.txt"),
        //     ]
        // ),
        // .executableTarget(
        //     name: "Day17",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day18",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day19",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
        // .executableTarget(
        //     name: "Day20",
        //     dependencies: ["Utils"],
        //     resources: [.process("input.txt"), .process("test.txt")]
        // ),
    ]
)
