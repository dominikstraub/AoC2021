import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> [String]? in
        if line == "" {
            return nil
        }
        return line
            .components(separatedBy: CharacterSet(charactersIn: "-"))
    }

func findPath(currentCave: String, paths: [String: Set<String>], smallCavesVisited: Set<String>, pathTaken: [String], singleSmallTwice: Bool) -> [[String]] {
    var pathTaken = pathTaken
    var smallCavesVisited = smallCavesVisited
    var pathsTaken = [[String]]()
    var singleSmallTwice = singleSmallTwice
    if smallCavesVisited.contains(currentCave) {
        if singleSmallTwice == true, currentCave != "start" {
            singleSmallTwice = false
        } else {
            return pathsTaken
        }
    }
    if currentCave[0].string == currentCave[0].string.lowercased() {
        smallCavesVisited.insert(currentCave)
    }
    pathTaken.append(currentCave)
    if currentCave == "end" {
        pathsTaken.append(pathTaken)
        return pathsTaken
    }
    for nextCave in paths[currentCave]! {
        pathsTaken.append(contentsOf: findPath(currentCave: nextCave, paths: paths, smallCavesVisited: smallCavesVisited, pathTaken: pathTaken, singleSmallTwice: singleSmallTwice))
    }
    return pathsTaken
}

func part1() -> Int {
    var paths = [String: Set<String>]()
    for line in lines {
        if paths[line[0]] == nil {
            paths[line[0]] = Set<String>()
        }
        paths[line[0]]!.insert(line[1])
        if paths[line[1]] == nil {
            paths[line[1]] = Set<String>()
        }
        paths[line[1]]!.insert(line[0])
    }

    let pathsTaken = findPath(currentCave: "start", paths: paths, smallCavesVisited: Set<String>(), pathTaken: [String](), singleSmallTwice: false)

    return pathsTaken.count
}

print("Part 1: \(part1())")

func part2() -> Int {
    var paths = [String: Set<String>]()
    for line in lines {
        if paths[line[0]] == nil {
            paths[line[0]] = Set<String>()
        }
        paths[line[0]]!.insert(line[1])
        if paths[line[1]] == nil {
            paths[line[1]] = Set<String>()
        }
        paths[line[1]]!.insert(line[0])
    }

    let pathsTaken = findPath(currentCave: "start", paths: paths, smallCavesVisited: Set<String>(), pathTaken: [String](), singleSmallTwice: true)

    return pathsTaken.count
}

print("Part 2: \(part2())")
