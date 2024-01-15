//
//  Day_13.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 6/1/2024.
//

import Foundation

class Day_13 {
    static func p(input: [String], partTwo: Bool) throws -> Int {
        do {
            // variable init
            var sum = 0
            var mirrorMap = [String]()
            
            // build each map or check reflection
            for line in input {
                if line.isEmpty {
                    sum += try checkReflection(map: mirrorMap, partTwo: partTwo)
                    
                    // clear for next map
                    mirrorMap.removeAll()
                } else {
                    mirrorMap.append(line)
                }
            }
            
            // for the last map, as there's no empty line to trigger it
            sum += try checkReflection(map: mirrorMap, partTwo: partTwo)
            
            return sum
        } catch {
            throw error
        }
    }
    
    private static func checkReflection(map: [String], partTwo: Bool) throws -> Int {
        var count = 0
        
        // check horizontally
        let horResult = checkRows(map: map, vertical: false, partTwo: partTwo)
        var verResult = (0, false)
        count = horResult.0
        
        if count == 0 || (partTwo && horResult.1 == false) {
            // transpose map
            var trspMap = [String]()
            for index in 0..<map.first!.count {
                let newLine = map.map{String($0[$0.index($0.startIndex, offsetBy: index)])}
                trspMap.append(newLine.joined())
            }
            
            // check vertically
            verResult = checkRows(map: trspMap, vertical: true, partTwo: partTwo)
            count = verResult.0 != 0 ? verResult.0 : count
        }
        
        // ensure reflection was found
        guard count != 0 && (!partTwo || (horResult.1 || verResult.1)) else { throw Day_13_Error.reflection_not_found(map: map) }
        return count
    }
    
    private static func checkRows(map: [String], vertical: Bool, partTwo: Bool) -> (Int,Bool) {
        var reflected = 0
        var smudgeFixed = false
        
        // check reflections on rows until out of bounds
        for y in 0..<map.count-1 {
            var valid = false
            smudgeFixed = false
            
            // get range we can check
            let bound = min(y, map.count-y-2)
            
            // check for perfect reflection
            for i in 0...bound {
                
                // for part two: verify with smudge once per pass
                if partTwo
                    && !smudgeFixed
                    && zip(map[y-i], map[y+i+1]).filter({$0 != $1}).count == 1 {
                    valid = true
                    smudgeFixed = true
                } else {
                    valid = map[y-i] == map[y+i+1]
                }
                
                // if the pattern is wrong, break early to avoid unnecessary calculations
                if partTwo ? (!valid && !smudgeFixed) : !valid { break }
            }
            
            // found the reflection, so sum according to rules
            if valid {
                reflected = vertical ? (y+1) : (y+1) * 100
                // keep searching if the smudged reflection has not been found
                if partTwo && !smudgeFixed {
                    continue
                } else {
                    break
                }
            }
        }
        return (reflected, smudgeFixed)
    }
    
    // custom error handling
    private enum Day_13_Error: Error {
        case reflection_not_found(map: [String])
    }
}
