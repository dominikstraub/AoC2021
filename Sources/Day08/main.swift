import Foundation
import Utils

if #available(macOS 12, *) {
    let input = try Utils.getInput(bundle: Bundle.module, file: "test")
    // let input = try Utils.getInput(bundle: Bundle.module)

    let lines = input
        .components(separatedBy: "\n")
        .compactMap { line -> [[String]]? in
            if line == "" {
                return nil
            }
            return line.components(separatedBy: " | ")
                .compactMap { part -> [String]? in
                    if part == "" {
                        return nil
                    }
                    return part.components(separatedBy: " ")
                        .compactMap { word -> String? in
                            if word == "" {
                                return nil
                            }
                            return word
                        }
                }
        }

    func part1() -> Int {
        let segmentCountOfUniqueCountNumbers = [2, 4, 3, 7]
        var countOfUniqueCountNumbers = 0
        for line in lines {
            for value in line[1] {
                if segmentCountOfUniqueCountNumbers.contains(value.count) {
                    countOfUniqueCountNumbers += 1
                }
            }
        }
        return countOfUniqueCountNumbers
    }

    print("Part 1: \(part1())")

    func part2() -> Int {
        // number: 0; segement count: 6; number count: 3
        // number: 1; segement count: 2; number count: 1
        // number: 2; segement count: 5; number count: 3
        // number: 3; segement count: 5; number count: 3
        // number: 4; segement count: 4; number count: 1
        // number: 5; segement count: 5; number count: 3
        // number: 6; segement count: 6; number count: 3
        // number: 7; segement count: 3; number count: 1
        // number: 8; segement count: 7; number count: 1
        // number: 9; segement count: 6; number count: 3
        let allChars: Set<Character> = ["a", "b", "c", "d", "e", "f", "g"]
        var score = 0
        for line in lines {
            var possibilities: [Character: Set<Character>] = [
                "a": ["a", "b", "c", "d", "e", "f", "g"],
                "b": ["a", "b", "c", "d", "e", "f", "g"],
                "c": ["a", "b", "c", "d", "e", "f", "g"],
                "d": ["a", "b", "c", "d", "e", "f", "g"],
                "e": ["a", "b", "c", "d", "e", "f", "g"],
                "f": ["a", "b", "c", "d", "e", "f", "g"],
                "g": ["a", "b", "c", "d", "e", "f", "g"],
            ]
            for value in line[0] {
                if value.count == 2 {
                    // number 1
                    // print(1)
                    for char in "cf" {
                        possibilities[char] = possibilities[char]?.intersection(value)
                    }
                    for char in allChars.subtracting("cf") {
                        possibilities[char] = possibilities[char]!.subtracting(value)
                    }
                } else if value.count == 4 {
                    // number 4
                    // print(4)
                    for char in "bcdf" {
                        possibilities[char] = possibilities[char]?.intersection(value)
                    }
                    for char in allChars.subtracting("bcdf") {
                        possibilities[char] = possibilities[char]!.subtracting(value)
                    }
                } else if value.count == 3 {
                    // number 7
                    // print(7)
                    for char in "acf" {
                        possibilities[char] = possibilities[char]?.intersection(value)
                    }
                    for char in allChars.subtracting("acf") {
                        possibilities[char] = possibilities[char]!.subtracting(value)
                    }
                }
            }
            for value in line[0] {
                let onePosibilities = possibilities["c"]!.union(possibilities["f"]!)
                let fourPosibilities = possibilities["b"]!.union(possibilities["c"]!).union(possibilities["d"]!).union(possibilities["f"]!)
                if value.count == 5 {
                    if onePosibilities.count == 2, value.contains(onePosibilities) {
                        // number 3
                        for char in "be" {
                            possibilities[char] = possibilities[char]!.subtracting(value)
                        }
                    }
                } else if value.count == 6 {
                    if fourPosibilities.count == 4, value.contains(fourPosibilities) {
                        // number 9
                        possibilities["e"] = possibilities["e"]!.subtracting(value)
                    } else if onePosibilities.count == 2, !value.contains(onePosibilities) {
                        // number 6
                        possibilities["c"] = possibilities["c"]!.subtracting(value)
                    } else if fourPosibilities.count == 4, onePosibilities.count == 2, value.contains(onePosibilities) {
                        // number 0
                        possibilities["d"] = possibilities["d"]!.subtracting(value)
                    }
                }
            }
            for (segment, segmentPossibilities) in possibilities where segmentPossibilities.count == 1 {
                for char in allChars.subtracting([segment]) {
                    // elimination
                    possibilities[char] = possibilities[char]!.subtracting(segmentPossibilities)
                }
            }

            var decodingTable = [Character: Character]()
            for (segment, segmentPossibilities) in possibilities {
                decodingTable[segmentPossibilities.first!] = segment
            }

            var localScore = 0
            for (i, value) in line[1].enumerated() {
                var val = 0
                if value.count == 7 {
                    val = 8
                } else if value.count == 2 {
                    val = 1
                } else if value.count == 4 {
                    val = 4
                } else if value.count == 3 {
                    val = 7
                } else if value.count == 6 {
                    if !value.contains(decodingTable["d"]!) {
                        val = 0
                    } else if !value.contains(decodingTable["c"]!) {
                        val = 6
                    } else {
                        val = 9
                    }
                } else {
                    if value.contains([decodingTable["b"]!, decodingTable["f"]!]) {
                        val = 5
                    } else if value.contains(decodingTable["f"]!) {
                        val = 3
                    } else {
                        val = 2
                    }
                }

                localScore += val * 10 ^^ (line[1].count - i - 1)
            }
            print(localScore)
            score += localScore
        }
        return score
    }

    print("Part 2: \(part2())")

} else {
    exit(-1)
}
