//
//  Day_13.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 6/1/2024.
//

import Foundation

struct Day_13 {
    static func p(input: [String], partOne: Bool) throws -> Int {
        var map = [String]()
        
        do {
            // variable init
            var sum = 0
            
            // build each map or check reflection
            for line in input {
                if line.isEmpty {
                    sum += try checkReflection()
                    
                    // clear for next map
                    map.removeAll()
                } else {
                    map.append(line)
                }
            }
            
            // for the last map, as there's no empty line to trigger it
            sum += try checkReflection()
            
            return sum
        } catch {
            throw error
        }
        
        func checkReflection() throws -> Int {
            var count = 0
            
            // check horizontally
            let horResult = checkRows(map: map, vertical: false)
            var verResult = (0, false)
            count = horResult.0
            
            if count == 0 || (!partOne && horResult.1 == false) {
                // transpose map
                var trspMap = [String]()
                for index in 0..<map.first!.count {
                    let newLine = map.map{String($0[$0.index($0.startIndex, offsetBy: index)])}
                    trspMap.append(newLine.joined())
                }
                
                // check vertically
                verResult = checkRows(map: trspMap, vertical: true)
                count = verResult.0 != 0 ? verResult.0 : count
            }
            
            // ensure reflection was found
            guard count != 0 && (partOne || (horResult.1 || verResult.1)) else { throw Day_13_Error.reflection_not_found(map: map) }
            return count
        }
        
        func checkRows(map: [String], vertical: Bool) -> (Int,Bool) {
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
                    if !partOne
                        && !smudgeFixed
                        && zip(map[y-i], map[y+i+1]).filter({$0 != $1}).count == 1 {
                        valid = true
                        smudgeFixed = true
                    } else {
                        valid = map[y-i] == map[y+i+1]
                    }
                    
                    // if the pattern is wrong, break early to avoid unnecessary calculations
                    if partOne ? !valid : (!valid && !smudgeFixed) { break }
                }
                
                // found the reflection, so sum according to rules
                if valid {
                    reflected = vertical ? (y+1) : (y+1) * 100
                    // keep searching if the smudged reflection has not been found
                    if !partOne && !smudgeFixed {
                        continue
                    } else {
                        break
                    }
                }
            }
            return (reflected, smudgeFixed)
        }
    }
    
    // custom error handling
    private enum Day_13_Error: Error {
        case reflection_not_found(map: [String])
    }
}
