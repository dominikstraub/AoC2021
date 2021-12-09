import Foundation
import Utils

let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module)

let field = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> [Int]? in
        if line == "" {
            return nil
        }
        return line.compactMap { point -> Int? in
            if point.string == "" {
                return nil
            }
            return Int(point.string)
        }
    }

// func part1() -> Int {
//     var risk = 0
//     for (y, line) in field.enumerated() {
//         for (x, point) in line.enumerated() {
//             if x > 0, line[x - 1] <= point {
//                 continue
//             }
//             if x < line.count - 1, line[x + 1] <= point {
//                 continue
//             }
//             if y > 0, field[y - 1][x] <= point {
//                 continue
//             }
//             if y < field.count - 1, field[y + 1][x] <= point {
//                 continue
//             }
//             risk += point + 1
//         }
//     }
//     return risk
// }

// print("Part 1: \(part1())")

func measureBasin(x: Int, y: Int, countedField: inout [Int: [Int: Bool]], field: [[Int]]) -> Int {
    var size = 1
    var x2 = x - 1
    while x2 >= 0, field[y][x2] != 9 {
        if countedField[y]![x2] == nil {
            countedField[y]![x2] = true
            size += measureBasin(x: x2, y: y, countedField: &countedField, field: field)
            x2 -= 1
        }
    }
    x2 = x + 1
    while x2 < field[y].count - 1, field[y][x2] != 9 {
        if countedField[y]![x2] == nil {
            countedField[y]![x2] = true
            size += measureBasin(x: x2, y: y, countedField: &countedField, field: field)
            x2 += 1
        }
    }
    var y2 = y - 1
    while y2 >= 0, field[y2][x] != 9 {
        if countedField[y2]![x] == nil {
            countedField[y2]![x] = true
            size += measureBasin(x: x2, y: y, countedField: &countedField, field: field)
            y2 -= 1
        }
    }
    y2 = y + 1
    while y2 < field.count - 1, field[y2][x] != 9 {
        if countedField[y2]![x] == nil {
            countedField[y2]![x] = true
            size += measureBasin(x: x2, y: y, countedField: &countedField, field: field)
            y2 += 1
        }
    }
    return size
}

func part2() -> Int {
    var basins = [Int]()
    for (y, _) in field.enumerated() {
        for (x, _) in field[y].enumerated() {
            if x > 0, field[y][x - 1] <= field[y][x] {
                continue
            }
            if x < field[y].count - 1, field[y][x + 1] <= field[y][x] {
                continue
            }
            if y > 0, field[y - 1][x] <= field[y][x] {
                continue
            }
            if y < field.count - 1, field[y + 1][x] <= field[y][x] {
                continue
            }
            var countedField = [Int: [Int: Bool]]()
            let size = measureBasin(x: x, y: y, countedField: &countedField, field: field)
            basins.append(size)
        }
    }

    return basins[0 ... 2].product()
}

print("Part 2: \(part2())")
