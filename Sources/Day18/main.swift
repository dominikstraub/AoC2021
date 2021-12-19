import Foundation
import Utils

class SnailUnit: CustomStringConvertible {
    var regularNumber: Int?
    var snailNumber: SnailNumber?
    var parent: SnailNumber?

    init(regularNumber: Int) {
        self.regularNumber = regularNumber
    }

    init(snailNumber: SnailNumber) {
        self.snailNumber = snailNumber
        self.snailNumber?.parent = self
    }

    init(input: String) {
        if input[0] == "[" {
            snailNumber = SnailNumber(input: String(input[0 ..< input.count]))
            snailNumber?.parent = self
        } else {
            regularNumber = Int(input[0].string)
        }
    }

    public var nestedNumberCount: Int {
        if let snailNumber = snailNumber {
            return snailNumber.nestedNumberCount + 1
        } else {
            return 0
        }
    }

    public func nestedNumber(level: Int) -> SnailNumber? {
        return snailNumber?.nestedNumber(level: level - 1)
    }

    public var bigUnit: SnailUnit? {
        if let regularNumber = regularNumber {
            if regularNumber >= 10 {
                return self
            } else {
                return nil
            }
        } else {
            return snailNumber?.bigUnit
        }
    }

    public var splitted: SnailUnit {
        if let regularNumber = regularNumber {
            if regularNumber >= 10 {
                return SnailUnit(snailNumber: SnailNumber(x: SnailUnit(regularNumber: Int(floor(Double(regularNumber) / 2))), y: SnailUnit(regularNumber: Int(ceil(Double(regularNumber) / 2)))))
            }
        }
        return self
    }

    public var magnitude: Int {
        return regularNumber ?? snailNumber?.magnitude ?? -1
    }

    public var description: String {
        regularNumber?.string ?? snailNumber?.description ?? "error"
    }

    public var string: String {
        description
    }
}

extension SnailUnit: Equatable {
    static func == (lhs: SnailUnit, rhs: SnailUnit) -> Bool {
        if let regularNumber = lhs.regularNumber {
            return regularNumber == rhs.regularNumber
        }
        if let snailNumber = lhs.snailNumber {
            return snailNumber == rhs.snailNumber
        }
        return rhs.regularNumber == nil && rhs.snailNumber == nil
    }
}

class SnailNumber: CustomStringConvertible {
    var x: SnailUnit?
    var y: SnailUnit?
    var parent: SnailUnit?

    init(x: SnailNumber, y: SnailNumber) {
        self.x = SnailUnit(snailNumber: x)
        self.x?.parent = self
        self.y = SnailUnit(snailNumber: y)
        self.y?.parent = self
    }

    init(x: SnailUnit, y: SnailUnit) {
        self.x = x
        self.x?.parent = self
        self.y = y
        self.y?.parent = self
    }

    init(input: String) {
        var openBrackets = 0
        for (i, char) in input.enumerated() {
            switch char {
            case "[":
                openBrackets += 1
                if openBrackets == 1 {
                    x = SnailUnit(input: String(input[i + 1 ..< input.count]))
                    x?.parent = self
                }
            case "]":
                openBrackets -= 1
            case ",":
                if openBrackets == 1 {
                    y = SnailUnit(input: String(input[i + 1 ..< input.count]))
                    y?.parent = self
                }
            default:
                break
            }

            if openBrackets == 0 {
                break
            }
        }
    }

    public var nestedNumberCount: Int {
        max(x?.nestedNumberCount ?? -1, y?.nestedNumberCount ?? -1)
    }

    public func nestedNumber(level: Int) -> SnailNumber? {
        if level == 0 {
            return self
        } else {
            return x?.nestedNumber(level: level) ?? y?.nestedNumber(level: level)
        }
    }

    public func explode() {
        let nestedNumber = self.nestedNumber(level: 4)

        var currentNumber = nestedNumber
        var nextNumber = nestedNumber?.parent?.parent
        while nextNumber != nil {
            if nextNumber?.x?.snailNumber === currentNumber {
                currentNumber = nextNumber
                nextNumber = nextNumber?.parent?.parent
            } else if nextNumber?.y?.snailNumber === currentNumber {
                currentNumber = nextNumber
                nextNumber = nextNumber?.x?.snailNumber
                if let regularNumber = currentNumber?.x?.regularNumber {
                    currentNumber?.x?.regularNumber = regularNumber + (nestedNumber?.x?.regularNumber ?? 0)
                    break
                }
            } else {
                currentNumber = nextNumber
                nextNumber = nextNumber?.y?.snailNumber
                if let regularNumber = currentNumber?.y?.regularNumber {
                    currentNumber?.y?.regularNumber = regularNumber + (nestedNumber?.x?.regularNumber ?? 0)
                    break
                }
            }
        }

        currentNumber = nestedNumber
        nextNumber = nestedNumber?.parent?.parent
        while nextNumber != nil {
            if nextNumber?.y?.snailNumber === currentNumber {
                currentNumber = nextNumber
                nextNumber = nextNumber?.parent?.parent
            } else if nextNumber?.x?.snailNumber === currentNumber {
                currentNumber = nextNumber
                nextNumber = nextNumber?.y?.snailNumber
                if let regularNumber = currentNumber?.y?.regularNumber {
                    currentNumber?.y?.regularNumber = regularNumber + (nestedNumber?.y?.regularNumber ?? 0)
                    break
                }
            } else {
                currentNumber = nextNumber
                nextNumber = nextNumber?.x?.snailNumber
                if let regularNumber = currentNumber?.x?.regularNumber {
                    currentNumber?.x?.regularNumber = regularNumber + (nestedNumber?.y?.regularNumber ?? 0)
                    break
                }
            }
        }

        nestedNumber?.parent?.regularNumber = 0
        nestedNumber?.parent?.snailNumber = nil
    }

    public var bigUnit: SnailUnit? {
        x?.bigUnit ?? y?.bigUnit
    }

    public var magnitude: Int {
        return 3 * x!.magnitude + 2 * y!.magnitude
    }

    public func reduce() -> SnailNumber {
        while true {
            if nestedNumberCount >= 4 {
                explode()
                continue
            }
            if let bigUnit = bigUnit {
                let splitted = bigUnit.splitted
                splitted.parent = bigUnit.parent
                if bigUnit.parent?.x === bigUnit {
                    bigUnit.parent?.x = splitted
                } else if bigUnit.parent?.y === bigUnit {
                    bigUnit.parent?.y = splitted
                }
                continue
            }
            break
        }
        return self
    }

    public var description: String {
        "[\(x?.string ?? "error"),\(y?.string ?? "error")]"
    }

    public var string: String {
        description
    }
}

infix operator +: AdditionPrecedence
extension SnailNumber {
    static func + (lhs: SnailNumber, rhs: SnailNumber) -> SnailNumber {
        return SnailNumber(x: lhs, y: rhs).reduce()
    }
}

extension SnailNumber: Equatable {
    // extension SnailNumber: AdditiveArithmetic {
    // static var zero: SnailNumber {
    //     <#code#>
    // }

    static func == (lhs: SnailNumber, rhs: SnailNumber) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> SnailNumber? in
        if line == "" {
            return nil
        }
        return SnailNumber(input: line)
    }

func part1() -> Int {
    var lines = lines
    var sum = lines.first!
    lines.remove(at: 0)
    for line in lines {
        sum = sum + line
    }
    return sum.magnitude
    // return lines.sum().magnitude
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
