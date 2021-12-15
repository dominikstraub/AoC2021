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
var pathTaken = [GridPoint: [GridPoint]]()
let size = lines.count
func findShortestPath(x: Int, y: Int, currentPath: Set<GridPoint> = [], backwardsCounter: Int = 0, tileCount: Int = 1) -> (risk: Int, path: [GridPoint])? {
    if y < 0 || x < 0 || y >= size * tileCount || x >= size * tileCount {
        return nil
    }
    let currentGridPoint = GridPoint(x: x, y: y)
    if let result = pathLengths[currentGridPoint] {
        return (risk: result, path: pathTaken[currentGridPoint]!)
    }
    let risk = ((lines[y % size][x % size] + y / size + x / size) - 1) % 9 + 1
    if y == size * tileCount - 1, x == size * tileCount - 1 {
        return (risk: risk, path: [currentGridPoint])
    }

    if currentPath.contains(currentGridPoint) {
        return nil
    }
    var currentPath = currentPath
    currentPath.insert(currentGridPoint)

    let rigthResult = findShortestPath(x: x + 1, y: y, currentPath: currentPath, backwardsCounter: backwardsCounter, tileCount: tileCount)
    let bottomResult = findShortestPath(x: x, y: y + 1, currentPath: currentPath, backwardsCounter: backwardsCounter, tileCount: tileCount)
    var leftResult: (risk: Int, path: [GridPoint])?
    var topResult: (risk: Int, path: [GridPoint])?
    if backwardsCounter < 10 {
        leftResult = findShortestPath(x: x - 1, y: y, currentPath: currentPath, backwardsCounter: backwardsCounter + 1, tileCount: tileCount)
        topResult = findShortestPath(x: x, y: y - 1, currentPath: currentPath, backwardsCounter: backwardsCounter + 1, tileCount: tileCount)
    }
    let results = [rigthResult, leftResult, bottomResult, topResult].compactMap { $0 }
    guard let min = results.map({ $0.risk }).min() else {
        return nil
    }
    let totalRisk = risk + min
    var path = [currentGridPoint]
    path.append(contentsOf: results.filter { $0.risk == min }.first!.path)
    pathLengths[currentGridPoint] = totalRisk
    pathTaken[currentGridPoint] = path
    return (risk: totalRisk, path: path)
}

let characterMatching = [
    0: "0️⃣",
    1: "1️⃣",
    2: "2️⃣",
    3: "3️⃣",
    4: "4️⃣",
    5: "5️⃣",
    6: "6️⃣",
    7: "7️⃣",
    8: "8️⃣",
    9: "9️⃣",
]

func wanderPath(tileCount: Int = 1) {
    var path = pathTaken[GridPoint(x: 0, y: 0)]!
    for y in 0 ..< size * tileCount {
        for x in 0 ..< size * tileCount {
            let risk = ((lines[y % size][x % size] + y / size + x / size) - 1) % 9 + 1
            if path.first == GridPoint(x: x, y: y) {
                path.remove(at: 0)
                print("\(characterMatching[risk]!) ", terminator: "")
            } else {
                print("\(risk) ", terminator: "")
            }
        }
        print()
    }
}

func printField(field: [[Int]]) {
    for line in field {
        for cell in line {
            print(cell, terminator: "")
        }
        print()
    }
}

// func part1() -> Int {
//     printField(field: lines)
//     print()
//     let result = findShortestPath(x: 0, y: 0)!.risk - lines[0][0]
//     print(pathTaken[GridPoint(x: 0, y: 0)]!)
//     return result
// }

// print("Part 1: \(part1())")

func part2() -> Int {
    // pathLengths = [GridPoint: Int]()
    let result = findShortestPath(x: 0, y: 0, tileCount: 5)!.risk - lines[0][0]
    wanderPath(tileCount: 5)
    return result
}

print("Part 2: \(part2())")
