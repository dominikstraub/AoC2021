import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let numbers = input
    .components(separatedBy: CharacterSet(charactersIn: ",\n"))
    .compactMap { nr -> Int? in
        if nr == "" {
            return nil
        }
        return Int(nr)
    }

func part1() -> Int {
    var fishes = numbers
    for _ in 1 ... 80 {
        for i in 0 ..< fishes.count {
            if fishes[i] == 0 {
                fishes.append(8)
                fishes[i] = 6
            } else {
                fishes[i] -= 1
            }
        }
    }
    return fishes.count
}

print("Part 1: \(part1())")

func part2() -> Int {
    var fishes = Array(repeating: 0, count: 10)
    for fish in numbers {
        fishes[fish] += 1
    }
    for _ in 1 ... 256 {
        fishes[9] = fishes[0]
        fishes[7] += fishes[0]
        for i in 0 ... 8 {
            fishes[i] = fishes[i + 1]
        }
    }
    fishes[9] = 0
    var totalCount = 0
    for count in fishes {
        totalCount += count
    }
    return totalCount
}

print("Part 2: \(part2())")
