//
//  Day_15.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 9/1/2024.
//

import Foundation
import Collections

struct Day_15 {
    static func p1(input: [String]) -> Int {
        // get the data from the input file
        let initSeq = input.first!
        let initSteps = initSeq.components(separatedBy: ",")
        
        // variable init
        var sum = 0
        
        // iterate through steps with HASH algorithm
        for step in initSteps {
            var hashSum = 0
            for char in step {
                hashSum += Int(char.asciiValue!)
                hashSum *= 17
                hashSum %= 256
            }
            sum += hashSum
        }
        
        return sum
    }
    
    static func p2(input: [String]) throws -> Int {
        do {
            // get the data from the input file
            let initSeq = input.first!
            let initSteps = initSeq.components(separatedBy: ",")
            
            // variable init
            var sum = 0
            var boxDict: [Int : OrderedDictionary<String,Int>] = [:]
            
            // iterate through steps with HASH algorithm
            for step in initSteps {
                // get components of step
                var hashSum = 0
                let label = step.components(separatedBy: .alphanumerics.inverted)
                let lens = label[0]
                let focalLength = Int(label[1]) ?? 0
                var operation: Character = " "
                
                // create hash value
                for char in step {
                    if !char.isLetter {
                        operation = char
                        break
                    }
                    hashSum += Int(char.asciiValue!)
                    hashSum *= 17
                    hashSum %= 256
                }
                
                switch operation {
                    // add the label to the box if it doesn't exist or update if it does
                case "=":
                    if boxDict[hashSum]?.contains(where: {$0.key == lens}) == nil {
                        boxDict[hashSum] = [lens : focalLength]
                    } else {
                        boxDict[hashSum]?.updateValue(focalLength, forKey: lens)
                    }
                    // remove the label from the box
                case "-":
                    boxDict[hashSum]?.removeValue(forKey: lens)
                default:
                    throw Day_15_Error.invalid_operation(operation: operation)
                }
            }
            
            // calculate the focal power
            for (boxNum, box) in boxDict {
                for (lens, focalLength) in box {
                    sum += (1 + boxNum) * (box.index(forKey: lens)! + 1) * focalLength
                }
            }
            
            return sum
        }
        catch {
            throw error
        }
    }
    
    // custom error handling
    private enum Day_15_Error: Error {
        case invalid_operation(operation: Character)
    }
}
