//
//  Day2.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 13/12/2023.
//

import Foundation

class Day2 {
    static func partOne() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 2)
            
            // variable init
            var sum = 0
            let maxCubeNums = [12, 13, 14] // rgb
            
            // iterate over lines
            for line in lines {
                
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
                            throw Day2Error.invalidColour(colour: colour)
                        }
                    }
                }
                
                // compare rgb to see if game would have been possible with limits
                if (maxCubeNums[0] >= currentGameMax[0]) && (maxCubeNums[1] >= currentGameMax[1]) && (maxCubeNums[2] >= currentGameMax[2]) {
                    sum += gameNum
                }
            }
            print(sum)
        } catch {
            print(error)
        }
    }
    
    static func partTwo() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 2)
            
            // variable init
            var sum = 0
            
            // iterate over lines
            for line in lines {
                
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
                            throw Day2Error.invalidColour(colour: colour)
                        }
                    }
                }
                
                // get the power of the cubes and sum it
                let powerNum = currentGameMax[0] * currentGameMax[1] * currentGameMax[2]
                sum += powerNum
            }
            print(sum)
        } catch {
            print(error)
        }
    }
    
    // custom error handling
    private enum Day2Error: Error {
        case invalidColour(colour: String)
    }
}
