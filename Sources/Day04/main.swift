import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

var inputs = input
    .components(separatedBy: "\n\n")
    .compactMap { input -> String? in
        if input == "" {
            return nil
        }
        return input
    }

let chosenNumbers = inputs[0].split(separator: ",").compactMap { number -> Int? in
    Int(number)
}

inputs.remove(at: 0)

var boards = inputs.compactMap { board -> [[(Int, Bool)]]? in
    if board == "" {
        return nil
    }
    return board.components(separatedBy: CharacterSet(charactersIn: "\n")).compactMap { line -> [(Int, Bool)]? in
        if line == "" {
            return nil
        }
        return line.components(separatedBy: CharacterSet(charactersIn: " ")).compactMap { number -> (Int, Bool)? in
            if number == "" {
                return nil
            }
            guard let nr = Int(number) else {
                return nil
            }
            return (nr, false)
        }
    }
}

func part1() -> Int {
    for chosenNumber in chosenNumbers {
        for (i, _) in boards.enumerated() {
            for (k, _) in boards[i].enumerated() {
                for (l, number) in boards[i][k].enumerated() where chosenNumber == number.0 {
                    boards[i][k][l].1 = true

                    var found = true
                    for m in 0 ... boards[i][k].count - 1 where boards[i][k][m].1 == false {
                        found = false
                        break
                    }
                    if found == false {
                        found = true
                        for m in 0 ... boards[i].count - 1 where boards[i][m][l].1 == false {
                            found = false
                            break
                        }
                    }
                    if found == true {
                        var score = 0
                        for line in boards[i] {
                            for number in line where number.1 == false {
                                score += number.0
                            }
                        }
                        score *= chosenNumber
                        return score
                    }
                }
            }
        }
    }

    return -1
}

print("Part 1: \(part1())")

func part2() -> Int {
    var winningScore = -1
    for chosenNumber in chosenNumbers {
        var i = 0
        while i < boards.count {
            var found = false
            for (k, _) in boards[i].enumerated() {
                if found == true {
                    break
                }
                for (l, number) in boards[i][k].enumerated() {
                    if found == true {
                        break
                    }
                    if chosenNumber == number.0 {
                        boards[i][k][l].1 = true

                        found = true
                        for m in 0 ... boards[i][k].count - 1 where boards[i][k][m].1 == false {
                            found = false
                            break
                        }
                        if found == false {
                            found = true
                            for m in 0 ... boards[i].count - 1 where boards[i][m][l].1 == false {
                                found = false
                                break
                            }
                        }
                        if found == true {
                            var score = 0
                            for line in boards[i] {
                                for number in line where number.1 == false {
                                    score += number.0
                                }
                            }
                            score *= chosenNumber
                            winningScore = score
                            boards.remove(at: i)
                            i -= 1
                        }
                    }
                }
            }
            i += 1
        }
    }

    return winningScore
}

print("Part 2: \(part2())")
