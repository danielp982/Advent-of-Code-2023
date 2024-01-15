//
//  Day_5.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 15/12/2023.
//

import Foundation

class Day_5 {
    static func p1(input: [String]) -> Int {
        // Dictionary initialisation to store all the mappings
        var seeds = [String]()
        var conversionMap: [[ClosedRange<Int> : Int]] = Array(repeating: [:], count: 7)
        var locations = [Int]()
        var status = 0
        
        for line in input {
            guard !line.isEmpty else { continue }
            
            // trigger for maps
            if line.hasSuffix(":") {
                status += 1
                continue
            }
            
            // build out the range dictionaries
            if status == 0 {
                seeds = line.components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
            } else {
                let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                let range = Int(mapLine[1])!...(Int(mapLine[1])!+Int(mapLine[2])!-1)
                let min = Int(mapLine[0])!
                conversionMap[status-1][range] = min
            }
        }
        
        // search each seed
        for seed in seeds {
            var currNum = Int(seed)!
            
            // search through each layer
            for map in conversionMap {
                for (key, value) in map {
                    let search = key.contains(currNum)
                    if (search) {
                        currNum = value + (currNum-key.lowerBound)
                        break
                    }
                }
            }
            locations.append(currNum)
        }
        return locations.min()!
    }
    
    static func p2(input: [String]) -> Int {
        // Dictionary initialisation to store all the mappings
        var seeds = [ClosedRange<Int>]()
        var conversionMap: [[ClosedRange<Int> : Int]] = Array(repeating: [:], count: 7)
        var status = 0
        
        for line in input {
            guard !line.isEmpty else { continue }
            
            // trigger for maps
            if line.hasSuffix(":") {
                status += 1
                continue
            }
            
            // build out the range dictionaries
            if status == 0 {
                let seedLine = line.components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
                for i in 0..<seedLine.count where (i % 2 == 0) {
                    seeds.append(Int(seedLine[i])!...(Int(seedLine[i])!+Int(seedLine[i+1])!-1))
                }
            } else {
                let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                let range = Int(mapLine[0])!...(Int(mapLine[0])!+Int(mapLine[2])!-1)
                let min = Int(mapLine[1])!
                conversionMap[7-status][range] = min
            }
        }
        
        // iterate by location and check if seed exists
        var locationNum = 0
        var seedFound = false
        
        repeat {
            var currNum = locationNum
            
            // search through each layer
            for map in conversionMap {
                for (key, value) in map {
                    let search = key.contains(currNum)
                    if (search) {
                        currNum = value + (currNum-key.lowerBound)
                        break
                    }
                }
            }
            
            // check if seed exists
            for seed in seeds {
                seedFound = seed.contains(currNum)
                if seedFound { break }
            }
            
            // new location to check
            if !seedFound { locationNum += 1 }
            
        } while !seedFound
        
        return locationNum
    }
}
