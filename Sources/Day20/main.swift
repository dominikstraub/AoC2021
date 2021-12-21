import Foundation
import Utils

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

let algorithm = parts[0]
    .compactMap { pixel -> Bool? in
        if pixel.string == "" {
            return nil
        }
        return pixel == "#"
    }

let image = parts[1]
    .components(separatedBy: "\n")
    .compactMap { line -> [Bool]? in
        if line == "" {
            return nil
        }
        return line
            .compactMap { pixel -> Bool? in
                if pixel.string == "" {
                    return nil
                }
                return pixel == "#"
            }
    }

func countPixels(image: [[Bool]]) -> Int {
    var count = 0
    for row in image {
        for pixel in row where pixel == true {
            count += 1
        }
    }
    return count
}

func enhance(image: [[Bool]], infinitePixel: Bool = false) -> [[Bool]]? {
    var outputImage = [[Bool]]()
    for y in -2 ... image.count + 2 {
        outputImage.append([Bool]())
        for x in -2 ... image[0].count + 2 {
            let filter = [
                image[safe: y - 1]?[safe: x - 1] ?? infinitePixel,
                image[safe: y - 1]?[safe: x] ?? infinitePixel,
                image[safe: y - 1]?[safe: x + 1] ?? infinitePixel,
                image[safe: y]?[safe: x - 1] ?? infinitePixel,
                image[safe: y]?[safe: x] ?? infinitePixel,
                image[safe: y]?[safe: x + 1] ?? infinitePixel,
                image[safe: y + 1]?[safe: x - 1] ?? infinitePixel,
                image[safe: y + 1]?[safe: x] ?? infinitePixel,
                image[safe: y + 1]?[safe: x + 1] ?? infinitePixel,
            ]
            let number = filter
                .compactMap { $0 == true ? "1" : "0" }
                .joined()
                .binToDec()
            let outputPixel = algorithm[number!]
            outputImage[y + 2].append(outputPixel)
        }
    }
    return outputImage
}

func print(image: [[Bool]]) {
    for row in image {
        for pixel in row {
            if pixel == true {
                print("#", terminator: "")
            } else {
                print(".", terminator: "")
            }
        }
        print()
    }
}

func part1() -> Int {
    print(algorithm)
    print(image)
    print()

    print(image: image)
    print()
    let once = enhance(image: image)!
    print(image: once)
    print()
    let twice = enhance(image: once, infinitePixel: algorithm[0])!
    print(image: twice)
    print()

    return countPixels(image: twice)
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
