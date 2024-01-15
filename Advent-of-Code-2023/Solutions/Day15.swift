//
//  Day15.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 9/1/2024.
//

import Foundation
import Collections

class Day15 {
    static func partOne() {
        do {
            // get the data from the input file
            let initSeq = try InputReader.readFile(day: 15).first!
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
            
            print(sum)
        }
        catch {
            print(error)
        }
    }
    
    static func partTwo() {
        do {
            // get the data from the input file
            let initSeq = try InputReader.readFile(day: 15).first!
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
                    throw Day15Error.invalidOperation(operation: operation)
                }
            }
            
            // calculate the focal power
            for (boxNum, box) in boxDict {
                for (lens, focalLength) in box {
                    sum += (1 + boxNum) * (box.index(forKey: lens)! + 1) * focalLength
                }
            }
            
            print(sum)
        }
        catch {
            print(error)
        }
    }
    
    // custom error handling
    private enum Day15Error: Error {
        case invalidOperation(operation: Character)
    }
}
