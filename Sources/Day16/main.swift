import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test2")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test3")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test4")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test5")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test6")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test7")
let input = try Utils.getInput(bundle: Bundle.module)

let transmission = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }.first!

let binary = transmission.hexToBin()

func parsePacket(pointer: Int) -> (value: Int, pointer: Int)? {
    var pointer = pointer
    let version = binary[pointer ..< pointer + 3].binToDec()!
    pointer += 3
    let type = binary[pointer ..< pointer + 3].binToDec()!
    pointer += 3
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
        guard let _ = binValue.binToDec() else { return nil }
        return (value: version, pointer: pointer)
    } else {
        // operator
        if binary[pointer] == "0" {
            // total length in bits
            pointer += 1
            var bitsLeft = binary[pointer ..< pointer + 15].binToDec()!
            pointer += 15
            var value = version
            while bitsLeft > 0 {
                guard let result = parsePacket(pointer: pointer) else { return nil }
                bitsLeft -= result.pointer - pointer
                value += result.value
                pointer = result.pointer
            }
            return (value: value, pointer: pointer)
        } else {
            // number of sub-packets
            pointer += 1
            var packetsLeft = binary[pointer ..< pointer + 11].binToDec()!
            pointer += 11
            var value = version
            while packetsLeft > 0 {
                guard let result = parsePacket(pointer: pointer) else { return nil }
                packetsLeft -= 1
                value += result.value
                pointer = result.pointer
            }
            return (value: value, pointer: pointer)
        }
    }
}

func part1() -> Int {
    // print(binary)
    if let result = parsePacket(pointer: 0) {
        return result.value
    }
    return -1
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
