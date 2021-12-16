import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test2")
let input = try Utils.getInput(bundle: Bundle.module)

let transmissions = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }

let binarys = transmissions.map { $0.hexToBin() }

func parsePacket(pointer: Int, binary: String, testing: Bool = false) -> (value: Int, pointer: Int)? {
    var pointer = pointer
    let version = binary[pointer ..< pointer + 3].binToDec()!
    pointer += 3
    let type = binary[pointer ..< pointer + 3].binToDec()!
    pointer += 3

    var value: Int?
    if type == 4 {
        // literal value
        var binValue = ""
        while pointer < binary.count {
            let endReached = binary[pointer] == "0"
            binValue += binary[pointer + 1 ... pointer + 4]
            pointer += 5
            if endReached {
                break
            }
        }
        if testing {
            value = version
        } else {
            value = binValue.binToDec()
        }
    } else {
        // operator
        var subValues = [Int]()
        if binary[pointer] == "0" {
            // total length in bits
            pointer += 1
            var bitsLeft = binary[pointer ..< pointer + 15].binToDec()!
            pointer += 15
            while bitsLeft > 0 {
                guard let result = parsePacket(pointer: pointer, binary: binary, testing: testing) else { return nil }
                bitsLeft -= result.pointer - pointer
                subValues.append(result.value)
                pointer = result.pointer
            }
        } else {
            // number of sub-packets
            pointer += 1
            var packetsLeft = binary[pointer ..< pointer + 11].binToDec()!
            pointer += 11
            while packetsLeft > 0 {
                guard let result = parsePacket(pointer: pointer, binary: binary, testing: testing) else { return nil }
                packetsLeft -= 1
                subValues.append(result.value)
                pointer = result.pointer
            }
        }

        if testing {
            value = version + subValues.sum()
        } else {
            switch type {
            case 0:
                value = subValues.sum()
            case 1:
                value = subValues.product()
            case 2:
                value = subValues.min()
            case 3:
                value = subValues.max()
            case 5:
                value = subValues[0] > subValues[1] ? 1 : 0
            case 6:
                value = subValues[0] < subValues[1] ? 1 : 0
            case 7:
                value = subValues[0] == subValues[1] ? 1 : 0
            default:
                break
            }
        }
    }
    guard let value = value else { return nil }
    return (value: value, pointer: pointer)
}

func part1() -> [Int] {
    return binarys.compactMap { parsePacket(pointer: 0, binary: $0, testing: true)?.value }
}

print("Part 1: \(part1())")

func part2() -> [Int] {
    return binarys.compactMap { parsePacket(pointer: 0, binary: $0)?.value }
}

print("Part 2: \(part2())")
