import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let parts = input
    .components(separatedBy: CharacterSet(charactersIn: "\n ,=."))
    .compactMap { part -> String? in
        if part == "" {
            return nil
        }
        return part
    }

let xMin = Int(parts[3])!
let xMax = Int(parts[4])!
let yMin = Int(parts[6])!
let yMax = Int(parts[7])!

func simulateShots() -> (highestY: Int, reachedtargetCount: Int) {
    var highestY: Int?
    var reachedtargetCount = 0

    for startVelocityX in 0 ... 300 {
        for startVelocityY in -300 ... 300 {
            // print("startVelocityX: \(startVelocityX), startVelocityY: \(startVelocityY)")
            var x = 0
            var y = 0
            var velocityX = startVelocityX
            var velocityY = startVelocityY
            var currentHighestY = y
            var step = 1
            while x <= xMax, y >= yMin {
                // print("startVelocityX: \(startVelocityX), startVelocityY: \(startVelocityY), step: \(step), velocityX: \(velocityX), velocityY: \(velocityY), x: \(x), y: \(y)")
                if currentHighestY < y {
                    currentHighestY = y
                }
                if x >= xMin, x <= xMax, y >= yMin, y <= yMax {
                    // print("startVelocityX: \(startVelocityX), startVelocityY: \(startVelocityY)")
                    if highestY == nil || highestY! < currentHighestY {
                        // print("startVelocityX: \(startVelocityX), startVelocityY: \(startVelocityY)")
                        highestY = currentHighestY
                    }
                    reachedtargetCount += 1
                    break
                }
                x += velocityX
                y += velocityY
                if velocityX > 0 {
                    velocityX -= 1
                }
                velocityY -= 1
                step += 1
            }
        }
    }
    return (highestY: highestY!, reachedtargetCount: reachedtargetCount)
}

let results = simulateShots()

func part1() -> Int {
    return results.highestY
}

print("Part 1: \(part1())")

func part2() -> Int {
    return results.reachedtargetCount
}

print("Part 2: \(part2())")
