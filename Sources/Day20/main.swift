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

func enhance(image: [[Bool]], infinitePixel: Bool = false) -> ([[Bool]], Bool) {
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
    let infinitePixel = algorithm[String(repeating: infinitePixel == true ? "1" : "0", count: 9).binToDec()!]
    return (outputImage, infinitePixel)
}

func print(image: [[Bool]], terminator: String = "\n") {
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
    print("", terminator)
}

func enhance(image: [[Bool]], times: Int) -> [[Bool]] {
    var (image, infinitePixel) = (image, false)

    for _ in 1 ... times {
        (image, infinitePixel) = enhance(image: image, infinitePixel: infinitePixel)
    }

    return image
}

func part1() -> Int {
    print(image: image)
    let image = enhance(image: image, times: 2)
    print(image: image)

    return countPixels(image: image)
}

print("Part 1: \(part1())")

func part2() -> Int {
    print(image: image)
    let image = enhance(image: image, times: 50)
    print(image: image)

    return countPixels(image: image)
}

print("Part 2: \(part2())")
