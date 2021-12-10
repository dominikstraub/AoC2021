import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> [Character]? in
        if line == "" {
            return nil
        }
        return Array(line)
    }

func part1() -> Int {
    let pointTable: [Character: Int] = [")": 3, "]": 57, "}": 1197, ">": 25137]
    let opening = Array("([{<")
    let pairs: [Character: Character] = ["(": ")", "[": "]", "{": "}", "<": ">"]
    var points = 0
    var stack = [Character]()
    for line in lines {
        for char in line {
            if opening.contains(char) {
                stack.append(char)
            } else if stack.isEmpty || pairs[stack.last!] == char {
                _ = stack.popLast()
            } else {
                points += pointTable[char]!
                break
            }
        }
    }
    return points
}

print("Part 1: \(part1())")

func part2() -> Int {
    let pointTable: [Character: Int] = [")": 1, "]": 2, "}": 3, ">": 4]
    let opening = Array("([{<")
    let pairs: [Character: Character] = ["(": ")", "[": "]", "{": "}", "<": ">"]
    var scores = [Int]()
    for line in lines {
        var stack = [Character]()
        var points = 0
        var corrupted = false
        for char in line {
            if opening.contains(char) {
                stack.append(char)
            } else if stack.isEmpty || pairs[stack.last!] == char {
                _ = stack.popLast()
            } else {
                corrupted = true
                break
            }
        }
        if stack.isEmpty || corrupted == true {
            continue
        }
        while !stack.isEmpty {
            points = points * 5 + pointTable[pairs[stack.popLast()!]!]!
        }
        scores.append(points)
    }
    return scores.sorted()[scores.count / 2]
}

print("Part 2: \(part2())")
