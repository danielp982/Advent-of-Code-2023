//
//  Day3.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 13/12/2023.
//

import Foundation

class Day3 {
    static func partOne() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 3)
            
            // variable init
            var sum = 0
            
            // iterate over lines
            for i in 1...lines.count {
                
                // lines to compare
                let topLine = i>=2 ? lines[i-2] : ""
                let centreLine = lines[i-1]
                let bottomLine = i<lines.count ? lines[i] : ""
                
                // regex match part numbers
                let matches = centreLine.ranges(of: /\d+/)
                
                // variable to help catch the upper bound check in the secondary for loop
                let centreLineIndexCheck = centreLine.index(centreLine.endIndex, offsetBy: 0)
                
                // go through the matches and check for machine parts
                for match in matches {
                    
                    // search range for the top and bottom lines (to factor in diagonals)
                    let newLowerBound = match.lowerBound == centreLine.startIndex ? match.lowerBound : centreLine.index(match.lowerBound, offsetBy: -1)
                    let newUpperBound = match.upperBound == centreLineIndexCheck ? centreLine.index(match.upperBound, offsetBy: -1) : centreLine.index(match.upperBound, offsetBy: 0)
                    let newRange = newLowerBound...newUpperBound
                    
                    // check for symbols in top, bottom and centre lines
                    let topLineCheck = i>=2 ? topLine[newRange].contains(/[^\w\s\.]/) : false
                    let centreLineCheck = centreLine[newRange].contains(/[^\w\s\.]/)
                    let bottomLineCheck = i<lines.count ? bottomLine[newRange].contains(/[^\w\s\.]/) : false
                    if topLineCheck || centreLineCheck || bottomLineCheck {
                        sum += Int(centreLine[match])!
                        
                    }
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
            let lines = try InputReader.readFile(day: 3)
            
            // variable init
            var sum = 0
            
            // iterate over lines
            for i in 1...lines.count {
                
                // lines to compare
                let topLine = i>=2 ? lines[i-2] : ""
                let centreLine = lines[i-1]
                let bottomLine = i<lines.count ? lines[i] : ""
                
                // regex match gears
                let matches = centreLine.ranges(of: /\*/)
                
                // variable to help catch the upper bound check in the secondary for loop
                let centreLineIndexCheck = centreLine.index(centreLine.endIndex, offsetBy: 0)
                
                // go through the matches and check for machine parts
                for match in matches {
                    
                    // search range for the top and bottom lines (to factor in diagonals)
                    let newLowerBound = match.lowerBound == centreLine.startIndex ? match.lowerBound : centreLine.index(match.lowerBound, offsetBy: -1)
                    let newUpperBound = match.upperBound == centreLineIndexCheck ? centreLine.index(match.upperBound, offsetBy: -1) : centreLine.index(match.upperBound, offsetBy: 0)
                    let newRange = newLowerBound...newUpperBound
                    
                    // check for numbers in top, bottom and centre lines
                    let topLineNumbers = i>=2 ? topLine[newRange].ranges(of: /\d+/) : []
                    let centreLineNumbers = centreLine[newRange].ranges(of: /\d+/)
                    let bottomLineNumbers = i<lines.count ? bottomLine[newRange].ranges(of: /\d+/) : []
                    
                    // sum the number of matches and ensuure it equals to 2
                    let numberCount = topLineNumbers.count + centreLineNumbers.count + bottomLineNumbers.count
                    
                    if numberCount == 2 {
                        var product = 1
                        
                        // only iterate through matches if line contains a match
                        for topNumber in topLineNumbers where topLineNumbers.count > 0 {
                            let allNumbers = topLine.ranges(of: /\d+/)
                            
                            // find the true number that matches the gear
                            for number in allNumbers {
                                if number.contains(topNumber.lowerBound) || number.contains(topNumber.upperBound) {
                                    product *= Int(topLine[number])!
                                    break
                                }
                            }
                        }
                        
                        // only iterate through matches if line contains a match
                        for centreNumber in centreLineNumbers where centreLineNumbers.count > 0 {
                            let allNumbers = centreLine.ranges(of: /\d+/)
                            
                            // find the true number that matches the gear
                            for number in allNumbers {
                                if number.contains(centreNumber.lowerBound) || number.contains(centreNumber.upperBound) {
                                    product *= Int(centreLine[number])!
                                    break
                                }
                            }
                        }
                        
                        // Only iterate through matches if line contains a match
                        for bottomNumber in bottomLineNumbers where bottomLineNumbers.count > 0 {
                            let allNumbers = bottomLine.ranges(of: /\d+/)
                            
                            // find the true number that matches the gear
                            for number in allNumbers {
                                if number.contains(bottomNumber.lowerBound) || number.contains(bottomNumber.upperBound) {
                                    product *= Int(bottomLine[number])!
                                    break
                                }
                            }
                        }
                        sum += product
                    }
                }
            }
            print(sum)
        } catch {
            print(error)
        }
    }
}
