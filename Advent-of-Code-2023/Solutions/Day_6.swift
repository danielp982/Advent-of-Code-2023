//
//  Day_6.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 18/12/2023.
//

import Foundation

struct Day_6 {
    static func p1(input: [String]) -> Int {
        // variable init
        var sum = 1
        var races = [(Int,Int)]()
        
        // extract values and add to dictionary
        let times = input[0].components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
        let distances = input[1].components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
        
        for i in times.indices {
            races.append((Int(times[i])!, Int(distances[i])!))
        }
        
        // iterate through races
        for race in races {
            let time = race.0
            let distance = race.1
            var noOfWins = 0
            
            // check hold times (excluding ones where the boat won't move)
            for holdTime in 1..<time {
                let myDistance = holdTime * (time - holdTime)
                if myDistance > distance {
                    noOfWins += 1
                }
            }
            sum *= noOfWins
        }
        return sum
    }
    
    static func p2(input: [String]) -> Int {
        // variable init
        var minHoldTime = 0
        
        // extract values and add to dictionary
        let time = Int(input[0].components(separatedBy: .decimalDigits.inverted).joined())!
        let distance = Int(input[1].components(separatedBy: .decimalDigits.inverted).joined())!
        
        // check for the min hold time
        for holdTime in 1..<time {
            let myDistance = holdTime * (time - holdTime)
            if myDistance > distance {
                minHoldTime = holdTime
                break
            }
        }
        
        // get the max hold time and solve the difference
        let noOfWins = time - (2 * minHoldTime) + 1
        
        return noOfWins
    }
}
