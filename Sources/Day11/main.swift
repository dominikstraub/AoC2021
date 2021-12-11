import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> [Int]? in
        if line == "" {
            return nil
        }
        return line.compactMap { number -> Int? in
            if number.string == "" {
                return nil
            }
            return Int(number.string)
        }
    }

func increase(x: Int, y: Int, octos: inout [[Int]]) -> Int {
    var flashes = 0
    octos[y][x] += 1
    if octos[y][x] == 10 {
        flashes += flash(x: x, y: y, octos: &octos)
    }
    return flashes
}

func flash(x: Int, y: Int, octos: inout [[Int]]) -> Int {
    var flashes = 1
    if x > 0 {
        flashes += increase(x: x - 1, y: y, octos: &octos)
    }
    if x < octos[y].count - 1 {
        flashes += increase(x: x + 1, y: y, octos: &octos)
    }
    if y > 0 {
        flashes += increase(x: x, y: y - 1, octos: &octos)
    }
    if y < octos.count - 1 {
        flashes += increase(x: x, y: y + 1, octos: &octos)
    }
    if x > 0, y > 0 {
        flashes += increase(x: x - 1, y: y - 1, octos: &octos)
    }
    if x < octos[y].count - 1, y > 0 {
        flashes += increase(x: x + 1, y: y - 1, octos: &octos)
    }
    if x > 0, y < octos.count - 1 {
        flashes += increase(x: x - 1, y: y + 1, octos: &octos)
    }
    if x < octos[y].count - 1, y < octos.count - 1 {
        flashes += increase(x: x + 1, y: y + 1, octos: &octos)
    }
    return flashes
}

func printOctos(octos: [[Int]]) {
    for line in octos {
        for octo in line {
            if octo == 0 {
                print(".", terminator: "")
            } else {
                print(octo, terminator: "")
            }
        }
        print()
    }
}

func part1() -> Int {
    var octos = lines
    var flashes = 0
    // printOctos(octos: octos)
    for _ in 1 ... 100 {
        // print(step)
        for (y, line) in octos.enumerated() {
            for (x, _) in line.enumerated() {
                flashes += increase(x: x, y: y, octos: &octos)
            }
        }
        for (y, line) in octos.enumerated() {
            for (x, octo) in line.enumerated() where octo > 9 {
                octos[y][x] = 0
            }
        }
        // printOctos(octos: octos)
    }
    return flashes
}

print("Part 1: \(part1())")

func part2() -> Int {
    var octos = lines
    let flashesNeeded = octos.count * octos[0].count
    for step in 1 ... 300 {
        var flashes = 0
        for (y, line) in octos.enumerated() {
            for (x, _) in line.enumerated() {
                flashes += increase(x: x, y: y, octos: &octos)
                if flashes >= flashesNeeded {
                    return step
                }
            }
        }
        for (y, line) in octos.enumerated() {
            for (x, octo) in line.enumerated() where octo > 9 {
                octos[y][x] = 0
            }
        }
    }
    return -1
}

print("Part 2: \(part2())")
