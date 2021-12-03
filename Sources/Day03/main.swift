import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let inputLines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .map { item -> [Bool]? in
        if item == "" {
            return nil
        }
        return Array(item)
            .map { $0 == "1" }
    }
    .compactMap { $0 }

func getMostCommon(lines: [[Bool]]) -> [Bool] {
    var gamma: [Bool] = Array(repeating: true, count: lines[0].count)
    for i in 0 ... lines[0].count - 1 {
        var trueCount = 0
        for k in 0 ... lines.count - 1 where lines[k][i] == true {
            trueCount += 1
        }
        if trueCount >= Int(round(Double(lines.count) / Double(2))) {
            gamma[i] = true
        } else {
            gamma[i] = false
        }
    }
    return gamma
}

func getDecNr(gamma: [Bool]) -> Int {
    var g = 0
    for i in 0 ... gamma.count - 1 where gamma[i] == true {
        g += 2 ^^ (gamma.count - i - 1)
    }
    return g
}

func getInverted(gamma: [Bool]) -> [Bool] {
    return gamma.map { t in
        !t
    }
}

func part1() -> Int {
    let gamma = getMostCommon(lines: inputLines)

    return getDecNr(gamma: gamma) * getDecNr(gamma: getInverted(gamma: gamma))
}

print("Part 1: \(part1())")

func part2() -> Int {
    var o2 = inputLines
    var co2 = inputLines
    for i in 0 ... inputLines[0].count - 1 {
        let gamma = getMostCommon(lines: o2)
        if o2.count > 1 {
            o2.removeAll { item in
                item[i] != gamma[i]
            }
        }

        let epsilon = getInverted(gamma: getMostCommon(lines: co2))
        if co2.count > 1 {
            co2.removeAll { item in
                item[i] != epsilon[i]
            }
        }
    }

    return getDecNr(gamma: o2[0]) * getDecNr(gamma: co2[0])
}

print("Part 2: \(part2())")
