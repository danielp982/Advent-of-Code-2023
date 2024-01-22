//
//  Day_11.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 27/12/2023.
//

import Foundation
import Algorithms

struct Day_11 {
    static func p1(input: [String]) -> Int {
        // variable init
        var starMap = [[String]]()
        var coords = [(Int, Int)]()
        var sum = 0
        
        // separate components of text into a 2D array (for loop used instead of reduce due to readability)
        for line in input {
            let brokenLine = line.map{String($0)}
            starMap.append(brokenLine)
            
            // reapply line if it contains no galaxies
            if !brokenLine.contains("#") {
                starMap.append(brokenLine)
            }
        }
        
        // transpose matrix
        var transposed = [[String]]()
        for index in 0..<starMap.first!.count {
            let newLine = starMap.map{$0[index]}
            transposed.append(newLine)
            
            // reapply line if it contains no galaxies
            if !newLine.contains("#") {
                transposed.append(newLine)
            }
        }
        
        // get coords of stars
        for (i, row) in transposed.indexed() {
            let xCoords = row.indices.filter{ row[$0].contains("#") }
            let _ = xCoords.reduce(into: coords, { coords.append(($1, i)) })
        }
        
        // sum the steps between each pair of galaxies
        for combination in coords.combinations(ofCount: 2) {
            sum += abs(combination[0].0 - combination[1].0) + abs(combination[0].1 - combination[1].1)
        }
        
        return sum
    }
    
    static func p2(input: [String]) -> Int {
        // variable init
        var starMap = [[String]]()
        var coords = [(Int, Int)]()
        var expandedRows = [Int]()
        var expandedCols = [Int]()
        var sum = 0
        
        // separate components of text into a 2D array (for loop used instead of reduce due to readability)
        for (i, line) in input.indexed() {
            let brokenLine = line.map{String($0)}
            starMap.append(brokenLine)
            
            // track line index if it contains no galaxies
            if !brokenLine.contains("#") {
                expandedRows.append(i)
            }
        }
        
        // transpose to check column expansions
        for index in 0..<starMap.first!.count {
            let newLine = starMap.map{$0[index]}
            
            // track line index if it contains no galaxies
            if !newLine.contains("#") {
                expandedCols.append(index)
            }
        }
        
        // get coords of stars
        for (i, row) in starMap.indexed() {
            let xCoords = row.indices.filter{ row[$0].contains("#") }
            let _ = xCoords.reduce(into: coords, { coords.append(($1, i)) })
        }
        
        // sum the steps between each pair of galaxies (factoring in expansion)
        for combination in coords.combinations(ofCount: 2) {
            // expand and sum x-coords
            let newX = [combination[0].0, combination[1].0].sorted()
            let xRange = newX[0]...newX[1]
            let noOfXExpansions = expandedCols.filter{xRange.contains($0)}.count
            let xSize = newX[1] - newX[0] + (999999 * noOfXExpansions)
            
            // expand and sum y-coords
            let newY = [combination[0].1, combination[1].1].sorted()
            let yRange = newY[0]...newY[1]
            let noOfYExpansions = expandedRows.filter{yRange.contains($0)}.count
            let ySize = newY[1] - newY[0] + (999999 * noOfYExpansions)
            
            sum += xSize + ySize
        }
        
        return sum
    }
}
