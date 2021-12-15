import Foundation
import Utils

struct GridPoint {
    var x: Int
    var y: Int
}

extension GridPoint: Hashable {
    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> [Int]? in
        if line == "" {
            return nil
        }
        return line.compactMap { risk -> Int? in
            if risk.string == "" {
                return nil
            }
            return Int(risk.string)
        }
    }

var pathLengths = [GridPoint: Int]()
let size = lines.count
func findShortestPath(x: Int, y: Int, tileCount: Int = 1) -> Int {
    if y >= size * tileCount {
        return Int.max
    }
    if x >= size * tileCount {
        return Int.max
    }
    if let result = pathLengths[GridPoint(x: x, y: y)] {
        return result
    }
    let risk = ((lines[y % size][x % size] + y / size + x / size) - 1) % 9 + 1
    if y == size * tileCount - 1, x == size * tileCount - 1 {
        return risk
    }

    let result = risk + min(findShortestPath(x: x + 1, y: y, tileCount: tileCount), findShortestPath(x: x, y: y + 1, tileCount: tileCount))
    pathLengths[GridPoint(x: x, y: y)] = result
    return result
}

func part1() -> Int {
    return findShortestPath(x: 0, y: 0) - lines[0][0]
}

print("Part 1: \(part1())")

func part2() -> Int {
    pathLengths = [GridPoint: Int]()
    return findShortestPath(x: 0, y: 0, tileCount: 5) - lines[0][0]
}

print("Part 2: \(part2())")
