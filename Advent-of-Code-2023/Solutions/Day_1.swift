//
//  Day_1.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 13/12/2023.
//

import Foundation
import Algorithms

struct Day_1 {
    static func p1(input: [String]) -> Int {
        // variable init
        var sum = 0
        
        // iterate over lines
        for line in input {
            
            // extract numbers from string
            let characters = line.components(separatedBy: .decimalDigits.inverted).joined()
            
            // get only first and last integers from new string
            let newCharacters = characters.prefix(1) + characters.suffix(1)
            let number = Int(newCharacters)!
            
            // sum up the total
            sum += number
        }
        return sum
    }
    
    static func p2(input: [String]) -> Int {
        // variable init
        var sum = 0
        
        // iterate over lines
        for line in input {
            
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
        return sum
    }
}
