//
//  Day_2.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 13/12/2023.
//

import Foundation

class Day_2 {
    static func p1(input: [String]) throws -> Int {
        do {
            // variable init
            var sum = 0
            let maxCubeNums = [12, 13, 14] // rgb
            
            // iterate over lines
            for line in input {
                
                // separate games with game numbers
                let game = line.components(separatedBy: [";", ":"])
                let gameNum = Int(game[0].trimmingCharacters(in: .decimalDigits.inverted))!
                
                var currentGameMax = [0, 0, 0] // rgb
                
                // iterate over each grab
                for grab in 1..<game.count {
                    // get individual cube colour and number pairs
                    let colours = game[grab].components(separatedBy: ",")
                    for colour in colours {
                        // check if the number is red, green, or blue
                        let checker = colour.suffix(1)
                        let colourNum = Int(colour.trimmingCharacters(in: .decimalDigits.inverted))!
                        
                        // check if the new grab had larger amounts than the previous
                        switch checker {
                        case "d":
                            currentGameMax[0] = max(colourNum, currentGameMax[0])
                        case "n":
                            currentGameMax[1] = max(colourNum, currentGameMax[1])
                        case "e":
                            currentGameMax[2] = max(colourNum, currentGameMax[2])
                        default:
                            throw Day_2_Error.invalid_colour(colour: colour)
                        }
                    }
                }
                
                // compare rgb to see if game would have been possible with limits
                if (maxCubeNums[0] >= currentGameMax[0]) && (maxCubeNums[1] >= currentGameMax[1]) && (maxCubeNums[2] >= currentGameMax[2]) {
                    sum += gameNum
                }
            }
            return sum
        } catch {
            throw error
        }
    }
    
    static func p2(input: [String]) throws -> Int {
        do {
            // variable init
            var sum = 0
            
            // iterate over lines
            for line in input {
                
                // separate games with game numbers
                let game = line.components(separatedBy: [";", ":"])
                
                var currentGameMax = [0, 0, 0] // rgb
                
                // iterate over each grab
                for grab in 1..<game.count {
                    // get individual cube colour and number pairs
                    let colours = game[grab].components(separatedBy: ",")
                    for colour in colours {
                        // check if the number is red, green, or blue
                        let checker = colour.suffix(1)
                        let colourNum = Int(colour.trimmingCharacters(in: .decimalDigits.inverted))!
                        
                        // check if the new grab had larger amounts than the previous
                        switch checker {
                        case "d":
                            currentGameMax[0] = max(colourNum, currentGameMax[0])
                        case "n":
                            currentGameMax[1] = max(colourNum, currentGameMax[1])
                        case "e":
                            currentGameMax[2] = max(colourNum, currentGameMax[2])
                        default:
                            throw Day_2_Error.invalid_colour(colour: colour)
                        }
                    }
                }
                
                // get the power of the cubes and sum it
                let powerNum = currentGameMax[0] * currentGameMax[1] * currentGameMax[2]
                sum += powerNum
            }
            return sum
        } catch {
            throw error
        }
    }
    
    // custom error handling
    private enum Day_2_Error: Error {
        case invalid_colour(colour: String)
    }
}
