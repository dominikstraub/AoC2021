import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let crabs = input
    .components(separatedBy: CharacterSet(charactersIn: ",\n"))
    .compactMap { nr -> Int? in
        if nr == "" {
            return nil
        }
        return Int(nr)
    }

func part1() -> Int {
    let sorted = crabs.sorted()
    let median = sorted[sorted.count / 2]

    var fuel = 0
    for crab in crabs {
        fuel += abs(crab - median)
    }
    return fuel
}

print("Part 1: \(part1())")

func part2() -> Int {
    var bestFuel: Int?
    // just a high enough max position
    for position in 0 ... 3000 {
        var fuel = 0
        for crab in crabs {
            let diff = abs(crab - position)
            fuel += diff * (diff + 1) / 2
        }
        if bestFuel == nil || fuel < bestFuel! {
            bestFuel = fuel
        }
    }
    return bestFuel ?? -1
}

print("Part 2: \(part2())")
