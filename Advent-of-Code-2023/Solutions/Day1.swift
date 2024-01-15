//
//  Day1.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 13/12/2023.
//

import Foundation
import Algorithms

class Day1 {
    static func partOne() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 1)
            
            // variable init
            var sum = 0
            
            // iterate over lines
            for line in lines {
                
                // extract numbers from string
                let characters = line.components(separatedBy: .decimalDigits.inverted).joined()
                
                // get only first and last integers from new string
                let newCharacters = characters.prefix(1) + characters.suffix(1)
                let number = Int(newCharacters)!
                
                // sum up the total
                sum += number
            }
            print(sum)
        } catch {
            print(error)
        }
    }
    
    static func partTwo() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 1)
            
            // variable init
            var sum = 0
            
            // iterate over lines
            for line in lines {
                
                let numArray = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
                
                var replacement = line
                
                // do the replacement from "one" to "nine"
                for (i, num) in numArray.indexed() {
                    if replacement.contains(num) {
                        // as words can be merged only replace the middle of the physcial word with the number
                        let replacementLine = num.prefix(1) + "\(i+1)" + num.suffix(1)
                        replacement = replacement.replacingOccurrences(of: num, with: replacementLine)
                    }
                }
                
                // extract numbers from new string
                let characters = replacement.components(separatedBy: .decimalDigits.inverted).joined()
                // get only first and last integers from new string
                let newCharacters = characters.prefix(1) + characters.suffix(1)
                let number = Int(newCharacters)!
                
                // sum up the total
                sum += number
            }
            print(sum)
        } catch {
            print(error)
        }
    }
}
