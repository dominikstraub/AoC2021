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

let parts = input
    .components(separatedBy: "\n\n")
    .compactMap { part -> String? in
        if part == "" {
            return nil
        }
        return part
    }

let points = parts[0]
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> GridPoint? in
        if line == "" {
            return nil
        }
        let coords = line.components(separatedBy: CharacterSet(charactersIn: ","))
        return GridPoint(x: Int(coords[0].string)!, y: Int(coords[1].string)!)
    }

let folds = parts[1]
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> (orientation: String, position: Int)? in
        if line == "" {
            return nil
        }
        let fold = line.components(separatedBy: CharacterSet(charactersIn: " ="))
        return (orientation: fold[2].string, position: Int(fold[3].string)!)
    }

func part1() -> Int {
    var points = Set(points)
    var foldedPoints = points
    let fold = folds[0]
    points = foldedPoints
    foldedPoints = Set<GridPoint>()
    for point in points {
        if fold.orientation == "y" {
            if point.y <= fold.position {
                foldedPoints.insert(point)
            } else {
                foldedPoints.insert(GridPoint(x: point.x, y: fold.position - (point.y - fold.position)))
            }
        } else if fold.orientation == "x" {
            if point.x <= fold.position {
                foldedPoints.insert(point)
            } else {
                foldedPoints.insert(GridPoint(x: fold.position - (point.x - fold.position), y: point.y))
            }
        }
    }
    return foldedPoints.count
}

print("Part 1: \(part1())")

func printPaper(points: Set<GridPoint>) {
    var paper = [[Bool]]()
    for point in points {
        while !paper.indices.contains(point.y) {
            paper.append([Bool]())
        }
        while !paper[point.y].indices.contains(point.x) {
            paper[point.y].append(false)
        }
        paper[point.y][point.x] = true
    }

    for y in 0 ... paper.indices.max()! {
        for x in 0 ... paper[y].indices.max()! {
            if paper[y][x] == true {
                print("#", terminator: "")
            } else {
                print(".", terminator: "")
            }
        }
        print()
    }
}

func part2() {
    var points = Set(points)
    var foldedPoints = points
    for fold in folds {
        points = foldedPoints
        foldedPoints = Set<GridPoint>()
        for point in points {
            if fold.orientation == "y" {
                if point.y <= fold.position {
                    foldedPoints.insert(point)
                } else {
                    foldedPoints.insert(GridPoint(x: point.x, y: fold.position - (point.y - fold.position)))
                }
            } else if fold.orientation == "x" {
                if point.x <= fold.position {
                    foldedPoints.insert(point)
                } else {
                    foldedPoints.insert(GridPoint(x: fold.position - (point.x - fold.position), y: point.y))
                }
            }
        }
    }

    print("Part 2:")
    printPaper(points: foldedPoints)
}

part2()
