import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let commands = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }.map { item -> (String, Int)? in
        let parts = item.components(separatedBy: CharacterSet(charactersIn: " "))
        let command = parts[0]
        guard let units = Int(parts[1]) else { return nil }
        return (command: command, units: units)
    }
    .compactMap { $0 }

func part1() -> Int {
    var x = 0
    var y = 0
    for command in commands {
        switch command.0 {
        case "forward":
            y += command.1
        case "up":
            x -= command.1
        case "down":
            x += command.1
        default: break
        }
    }
    return x * y
}

print("Part 1: \(part1())")

func part2() -> Int {
    var x = 0
    var y = 0
    var aim = 0
    for command in commands {
        switch command.0 {
        case "forward":
            x += command.1
            y += aim * command.1
        case "up":
            aim -= command.1
        case "down":
            aim += command.1
        default: break
        }
    }
    return x * y
}

print("Part 2: \(part2())")
