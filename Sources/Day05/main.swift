import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> (end1: (x: Int, y: Int), end2: (x: Int, y: Int))? in
        if line == "" {
            return nil
        }
        let coords = line.components(separatedBy: " -> ")
        let coord1 = coords[0].components(separatedBy: ",")
        let coord2 = coords[1].components(separatedBy: ",")
        guard let x1 = Int(coord1[0]),
              let y1 = Int(coord1[1]),
              let x2 = Int(coord2[0]),
              let y2 = Int(coord2[1]) else { return nil }

        return ((x1, y1), (x2, y2))
    }

func print(field: [Int: [Int: Int]]) {
    var field = field
    let maxY = field.keys.max() ?? 0
    for y in 0 ... maxY {
        if field[y] == nil {
            field[y] = [Int: Int]()
        }
        let maxX = field[y]!.keys.max() ?? 0
        for x in 0 ... maxX {
            if field[y]![x] == nil {
                field[y]![x] = 0
            }
            let cell = field[y]![x]!
            if cell <= 0 {
                print(".", terminator: "")
            } else {
                print(field[y]![x]!, terminator: "")
            }
        }
        print("")
    }
}

func countDangerousPoints(field: [Int: [Int: Int]]) -> Int {
    var dangerousCount = 0
    for (_, line) in field {
        for (_, cell) in line {
            if cell >= 2 {
                dangerousCount += 1
            }
        }
    }
    return dangerousCount
}

func part1() -> Int {
    var field = [Int: [Int: Int]]()
    for line in lines {
        var x1 = line.end1.x
        var x2 = line.end2.x
        var y1 = line.end1.y
        var y2 = line.end2.y
        if x2 < x1 {
            (x1, x2) = (x2, x1)
        }
        if y2 < y1 {
            (y1, y2) = (y2, y1)
        }

        if x1 == x2 {
            let x = x1
            for y in y1 ... y2 {
                if field[y] == nil {
                    field[y] = [Int: Int]()
                }
                if field[y]![x] == nil {
                    field[y]![x] = 0
                }

                field[y]![x]! += 1
            }
        } else if y1 == y2 {
            let y = y1
            for x in x1 ... x2 {
                if field[y] == nil {
                    field[y] = [Int: Int]()
                }
                if field[y]![x] == nil {
                    field[y]![x] = 0
                }

                field[y]![x]! += 1
            }
        }
    }
    // print(field: field)
    return countDangerousPoints(field: field)
}

print("Part 1: \(part1())")

func part2() -> Int {
    var field = [Int: [Int: Int]]()
    for line in lines {
        var x1 = line.end1.x
        var x2 = line.end2.x
        var y1 = line.end1.y
        var y2 = line.end2.y

        var dir = 1
        if x2 < x1 {
            (x1, x2) = (x2, x1)
            (y1, y2) = (y2, y1)
        }
        if y2 < y1 {
            dir = -1
        } else if y2 == y1 {
            dir = 0
        }

        if x1 == x2 {
            let x = x1
            if y2 < y1 {
                (y1, y2) = (y2, y1)
            }
            for y in y1 ... y2 {
                if field[y] == nil {
                    field[y] = [Int: Int]()
                }
                if field[y]![x] == nil {
                    field[y]![x] = 0
                }

                field[y]![x]! += 1
            }
        } else {
            var y = y1
            for x in x1 ... x2 {
                if field[y] == nil {
                    field[y] = [Int: Int]()
                }
                if field[y]![x] == nil {
                    field[y]![x] = 0
                }

                field[y]![x]! += 1
                y += dir
            }
        }
    }
    // print(field: field)
    return countDangerousPoints(field: field)
}

print("Part 2: \(part2())")
