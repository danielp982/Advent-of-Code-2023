//
//  Day_14.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 8/1/2024.
//

import Foundation
import Algorithms

class Day_14 {
    static func p1(input: [String]) -> Int {
        // variable init
        var sum = 0
        
        // run rotate cycle
        let newMap = rotateAndSort(loadMap: input)
        
        // sum the load on the rocks
        for line in newMap {
            for (i, rock) in line.indexed() {
                if rock == "O" {
                    let ii = i.utf16Offset(in: line)
                    sum += ii+1
                }
            }
        }
        
        return sum
    }
    
    
    static func p2(input: [String]) -> Int {
        // variable init
        var sum = 0
        var spinCount = 0
        var cycles = [Int]()
        var prevStates = [[String]]()
        var loadMap = input
        
        // run spin cycles
        for direction in Direction.allCases.cycled() {
            loadMap = rotateAndSort(loadMap: loadMap)
            
            // check if this north direction is repeating
            if direction == .east {
                spinCount += 1
                
                // determine indices of cycle
                if prevStates.contains(loadMap) {
                    if cycles.isEmpty {
                        cycles.append(prevStates.firstIndex(of: loadMap)! + 1)
                    }
                    cycles.append(spinCount)
                    prevStates.removeAll()
                }
                
                // check if the cycle is a valid repetition and is on a cycle count equivalent to the requirement
                if cycles.count >= 3 && 1000000000 % spinCount == 0 {
                    if cycles.distance(from: cycles.count-2, to: cycles.count-1) == cycles.distance(from: cycles.count-3, to: cycles.count-2) {
                        break
                    }
                }
                prevStates.append(loadMap)
            }
        }
        
        // sum the load on the rocks
        for (i, line) in loadMap.indexed() {
            sum += line.filter{$0 == "O"}.count * (loadMap.count-i)
        }
        
        return sum
    }
    
    private static func rotateAndSort(loadMap: [String]) -> [String] {
        var newMap = [String]()
        
        // rotate clockwise and calculate map
        for index in 0..<loadMap.first!.count {
            let newLine = loadMap.reversed().map{String($0[$0.index($0.startIndex, offsetBy: index)])}.joined()
            
            // split and "roll" (sort) the rocks
            let rockGroups = newLine.components(separatedBy: "#")
            var newRockGroups = [String]()
            for group in rockGroups {
                newRockGroups.append(String(group.sorted()))
            }
            let finalRocks = newRockGroups.joined(separator: "#")
            newMap.append(finalRocks)
        }
        return newMap
    }
    
    private enum Direction: CaseIterable {
        case north, west, south, east
    }
}
