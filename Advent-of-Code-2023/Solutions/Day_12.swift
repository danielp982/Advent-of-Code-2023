//
//  Day_12.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 28/12/2023.
//

import Foundation
import Algorithms

class Day_12 {
    static func p(input: [String], partTwo: Bool) throws -> Int {
        do {
            // variable init
            var sum = 0
            
            // format data
            for line in input {
                let lineDiv = line.components(separatedBy: " ")
                var springMap = lineDiv[0]
                var springArr = lineDiv[1].components(separatedBy: ",")
                
                // 5x the size for part two
                if partTwo {
                    springMap = String.init(repeating: springMap+"?", count: 5)
                    springMap = String(springMap.dropLast())
                    springArr = Array(repeating: springArr, count: 5).flatMap{$0}
                }
                
                springArr.append(springMap)
                
                // recursive solve
                let memoisedSolver = recursiveMemoize { (recursiveSolve, springArr: [String]) in
                    // credit u/StaticMoose
                    var sum = 0
                    let springs = springArr.last!
                    let groups = springArr.dropLast().map{Int($0)!}
                    
                    // check if no more groups, all remaining springs must be fixed
                    if groups.isEmpty {
                        if springs.contains("#") {
                            return 0
                        } else {
                            return 1
                        }
                    }
                    
                    // check if more groups but no more springs
                    if springs.isEmpty {
                        return 0
                    }
                    
                    // variables
                    let currSpring = springs.first!
                    let currGroup = groups[0]
                    
                    // logic to determine how to treat spring
                    switch currSpring {
                    case "#":
                        sum = hash()
                    case ".":
                        sum = dot()
                    case "?":
                        sum = hash() + dot()
                    default:
                        throw Day_12_Error.invalid_spring(spring: currSpring)
                    }
                    
                    func hash() -> Int {
                        // check if next set of springs fit
                        let springSet = springs.prefix(currGroup)
                        if springSet.contains(".") {
                            return 0
                        }
                        
                        // check if this is the final set
                        if springs.count == currGroup {
                            if groups.count == 1 {
                                return 1
                            } else {
                                return 0
                            }
                        }
                        
                        // check if broken size is not too large
                        if springs.count + 1 > currGroup {
                            let nextSpring = springs.index(springs.startIndex, offsetBy: currGroup)
                            if springs[nextSpring] != "#" {
                                var newMap = Array(groups.map{String($0)}.dropFirst())
                                newMap.append(String(springs.suffix(springs.count-currGroup-1)))
                                
                                return try! recursiveSolve(newMap)
                            }
                        }
                        
                        // no other options
                        return 0
                    }
                    
                    func dot() -> Int {
                        var newMap = groups.map{String($0)}
                        newMap.append(String(springs.dropFirst()))
                        return try! recursiveSolve(newMap)
                    }
                    
                    return sum
                }
                sum += try memoisedSolver(springArr)
            }
            
            return sum
        } catch {
            throw error
        }
    }
    
    // credit Hacking with Swift
    // I have not begun to fully process how this works but it does
    
    // work with any sort of input and output as long as the input is hashable, accept a function that takes Input and returns Output, and send back a function that accepts Input and returns Output
    private static func recursiveMemoize<Input: Hashable, Output>(_ function: @escaping ((Input) throws -> Output, Input) throws -> Output) -> (Input) throws -> Output {
        // our item cache
        var storage = [Input: Output]()
        
        // send back a new closure that does our calculation
        var memo: ((Input) throws -> Output)!
        memo = { input in
            if let cached = storage[input] {
                return cached
            }
            
            let result = try function(memo, input)
            storage[input] = result
            return result
        }
        
        return memo
    }
    
    // custom error handling
    private enum Day_12_Error: Error {
        case invalid_spring(spring: Character)
    }
}
