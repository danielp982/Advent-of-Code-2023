//
//  Day_16.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 15/1/2024.
//

import Foundation
import Algorithms

class Day_16 {
    static func p1(input: [String]) throws -> Int {
        do {
            var beamMap = [[String]]()
            
            // separate components of text into a 2D array (for loop used instead of reduce due to readability)
            for line in input {
                beamMap.append(line.map{String($0)})
            }
            
            // dimensions & starting coordinate
            let ySize = beamMap.count
            let xSize = beamMap[0].count
            
            // start flood fill
            let total = try floodFill(map: beamMap, xStart: 0, yStart: 0, xSize: xSize, ySize: ySize, initDir: .right)
            
            return total
        } catch {
            throw error
        }
    }
    
    static func p2(input: [String]) throws -> Int {
        do {
            var beamMap = [[String]]()
            
            // separate components of text into a 2D array (for loop used instead of reduce due to readability)
            for line in input {
                beamMap.append(line.map{String($0)})
            }
            
            // dimensions & starting coordinate
            let ySize = beamMap.count
            let xSize = beamMap[0].count
            var total = 0
            
            // start flood fill
            for (point, direction) in product(0..<ySize, Direction.allCases) {
                var xStart = 0
                var yStart = 0
                
                switch direction {
                case .up:
                    xStart = point
                    yStart = ySize-1
                case .down:
                    xStart = point
                    yStart = 0
                case .left:
                    xStart = xSize-1
                    yStart = point
                case .right:
                    xStart = 0
                    yStart = point
                }
                
                let temp = try floodFill(map: beamMap, xStart: xStart, yStart: yStart, xSize: xSize, ySize: ySize, initDir: direction)
                if temp > total { total = temp }
            }
            
            return total
        } catch {
            throw error
        }
    }
    
    private static func floodFill(map: [[String]], xStart: Int, yStart: Int, xSize: Int, ySize: Int, initDir: Direction) throws -> Int {
        // variable init
        var queue = [(Int, Int, Direction)]()
        var visitedCoords = Set<String>()
        var visitedWithDir = Set<String>()
        
        // append the position of starting pixel & direction of the component
        queue.append((xStart, yStart, initDir))
        
        // while the queue is not empty i.e. the whole component is not colored with the new color
        while queue.count > 0 {
            
            // dequeue the front node
            let currNode = queue.removeFirst()
            
            // get current coords and object
            let posX = currNode.0
            let posY = currNode.1
            let currDir = currNode.2
            let nodeKey = "\(currNode)"
            
            // check if the light beam is out of bounds or repeating a map segment we've done
            guard posX >= 0 && posX < xSize && posY >= 0 && posY < ySize && !visitedWithDir.contains(nodeKey) else { continue }
            
            // record that we've been here (directions for the repeats, coords for the total count)
            visitedCoords.insert("\(posX),\(posY)")
            visitedWithDir.insert(nodeKey)
            
            // setup
            let currObj = map[posY][posX]
            let nextPoints: [Direction : (Int, Int)] = [.right : (posX + 1, posY), .left : (posX - 1, posY), .up : (posX, posY - 1), .down : (posX, posY + 1)]
            
            // check which move to do next
            switch currObj {
            case "|": // vertical mirror
                if currDir == .up || currDir == .down {
                    // treat as ground
                    newDirection(direction: currDir, points: nextPoints)
                } else {
                    // split up & down
                    newDirection(direction: .up, points: nextPoints)
                    newDirection(direction: .down, points: nextPoints)
                }
            case "-": // horizontal mirror
                if currDir == .left || currDir == .right {
                    // treat as ground
                    newDirection(direction: currDir, points: nextPoints)
                } else {
                    // split left & right
                    newDirection(direction: .left, points: nextPoints)
                    newDirection(direction: .right, points: nextPoints)
                }
            case #"\"#: // bs mirror
                if currDir == .left {
                    // reflect up
                    newDirection(direction: .up, points: nextPoints)
                } else if currDir == .right {
                    // reflect down
                    newDirection(direction: .down, points: nextPoints)
                } else if currDir == .up {
                    // reflect left
                    newDirection(direction: .left, points: nextPoints)
                } else if currDir == .down {
                    // reflect right
                    newDirection(direction: .right, points: nextPoints)
                }
            case "/": // fs mirror
                if currDir == .left {
                    // reflect down
                    newDirection(direction: .down, points: nextPoints)
                } else if currDir == .right {
                    // reflect up
                    newDirection(direction: .up, points: nextPoints)
                } else if currDir == .up {
                    // reflect right
                    newDirection(direction: .right, points: nextPoints)
                } else if currDir == .down {
                    // reflect left
                    newDirection(direction: .left, points: nextPoints)
                }
            case ".": // space
                newDirection(direction: currDir, points: nextPoints)
            default: // not accounted for
                throw Day_16_Error.invalid_tile(tile: currObj)
            }
        }
        
        // helper function to manipulatr queue & floodmap
        func newDirection(direction: Direction, points: [Direction : (Int, Int)]) {
            let newPosX = points[direction]!.0
            let newPosY = points[direction]!.1
            queue.append((newPosX, newPosY, direction))
        }
        
        // get number of energised tiles
        return visitedCoords.count
    }
    
    private enum Direction: CaseIterable {
        case up, down, left, right
    }
    
    // custom error handling
    private enum Day_16_Error: Error {
        case invalid_tile(tile: String)
    }
}
