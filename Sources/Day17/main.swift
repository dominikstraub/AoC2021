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

func part1() -> Int {
    print(xMin)
    print(xMax)
    print(yMin)
    print(yMax)
    var highestY: Int?

    for startVelocityX in 0 ... 150 {
        for startVelocityY in -150 ... 150 {
            // print("startVelocityX: \(startVelocityX), startVelocityY: \(startVelocityY)")
            var x = 0
            var y = 0
            var velocityX = startVelocityX
            var velocityY = startVelocityY
            var targetReached = false
            var currentHighestY = y
            var step = 1
            while x <= xMax, y >= yMin {
                // print("startVelocityX: \(startVelocityX), startVelocityY: \(startVelocityY), step: \(step), velocityX: \(velocityX), velocityY: \(velocityY), x: \(x), y: \(y)")
                if currentHighestY < y {
                    currentHighestY = y
                }
                if x >= xMin, x <= xMax, y >= yMin, y <= yMax {
                    targetReached = true
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
            if targetReached == true, highestY == nil || highestY! < currentHighestY {
                // print("startVelocityX: \(startVelocityX), startVelocityY: \(startVelocityY)")
                highestY = currentHighestY
            }
        }
    }
    return highestY!
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
