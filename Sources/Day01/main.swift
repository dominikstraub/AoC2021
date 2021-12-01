import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }.map { item -> Int? in
        Int(item)
    }
    .compactMap { $0 }

func part1() -> Int {
    var count = 0
    var prev: Int?
    for line in lines {
        if let prev2 = prev {
            if line > prev2 {
                count += 1
            }
            prev = line
        } else {
            prev = line
        }
    }
    return count
}

print("Part 1: \(part1())")

func part2() -> Int {
    var count = 0
    var prev: Int?
    for index in 2 ... (lines.count - 1) {
        let current = lines[index] + lines[index - 1] + lines[index - 2]
        if let prev2 = prev {
            if current > prev2 {
                count += 1
            }
        }
        prev = current
    }
    return count
}

print("Part 2: \(part2())")
