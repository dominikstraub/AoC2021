import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let parts = input
    .components(separatedBy: "\n\n")
    .compactMap { part -> String? in
        if part == "" {
            return nil
        }
        return part
    }

let template = parts[0]

var rules = [String: String]()
parts[1]
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .forEach { line in
        if line == "" {
            return
        }
        let rule = line.components(separatedBy: " -> ")
        rules[rule[0]] = rule[1]
    }

func part1() -> Int {
    var template = template
    for _ in 1 ... 10 {
        let length = template.count
        for i in 1 ..< length {
            let index = length - i
            let pair = String(template[index - 1]) + String(template[index])
            if rules[pair] != nil {
                template.insert(contentsOf: rules[pair]!, at: template.index(template.startIndex, offsetBy: index))
            }
        }
    }

    var characterCount = [Character: Int]()
    for character in template {
        if characterCount[character] == nil {
            characterCount[character] = 0
        }
        characterCount[character]! += 1
    }
    var mostCommon: Int?
    var leastCommon: Int?
    for count in characterCount.values {
        if mostCommon == nil || count > mostCommon! {
            mostCommon = count
        }
        if leastCommon == nil || count < leastCommon! {
            leastCommon = count
        }
    }
    return mostCommon! - leastCommon!
}

print("Part 1: \(part1())")

func part2() -> Int {
    var pairCount = [String: Int]()
    for i in 1 ..< template.count {
        let pair = String(template[i - 1]) + String(template[i])
        if pairCount[pair] == nil {
            pairCount[pair] = 0
        }
        pairCount[pair]! += 1
    }

    for _ in 1 ... 40 {
        var stepPairCount = pairCount
        for (pair, count) in pairCount where rules[pair] != nil {
            if stepPairCount[pair[0].string + rules[pair]!] == nil {
                stepPairCount[pair[0].string + rules[pair]!] = 0
            }
            stepPairCount[pair[0].string + rules[pair]!]! += count

            if stepPairCount[rules[pair]! + pair[1].string] == nil {
                stepPairCount[rules[pair]! + pair[1].string] = 0
            }
            stepPairCount[rules[pair]! + pair[1].string]! += count

            stepPairCount[pair]! -= count
        }
        pairCount = stepPairCount
    }

    var characterCount = [Character: Int]()
    for (pair, count) in pairCount {
        characterCount[pair[0]] = (characterCount[pair[0]] ?? 0) + count
        characterCount[pair[1]] = (characterCount[pair[1]] ?? 0) + count
    }
    characterCount[template[0]]! += 1
    characterCount[template[template.count - 1]]! += 1

    var mostCommon: Int?
    var leastCommon: Int?
    for count in characterCount.values {
        if mostCommon == nil || count > mostCommon! {
            mostCommon = count
        }
        if leastCommon == nil || count < leastCommon! {
            leastCommon = count
        }
    }
    return (mostCommon! - leastCommon!) / 2
}

print("Part 2: \(part2())")
