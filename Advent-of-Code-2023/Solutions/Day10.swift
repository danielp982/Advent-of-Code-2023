//
//  Day10.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 22/12/2023.
//

import Foundation
import Algorithms

class Day10 {
    static func partOne() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 10)
            var pipeMap = [[String]]()
            
            // separate components of text into a 2D array (for loop used instead of reduce due to readability)
            for line in lines {
                pipeMap.append(line.map{ String($0) })
            }
            
            // dimensions
            let ySize = pipeMap.count
            let xSize = pipeMap[0].count
            
            // get starting coordinate
            var startPos = [0,0]
            for (y, row) in pipeMap.indexed() {
                let search = row.firstIndex(of: "S")
                if (search != nil) {
                    startPos[0] = search!
                    startPos[1] = y
                    break
                }
            }
            
            // copy of the map to fill in
            var colouredMap = pipeMap
            
            // start flood fill
            try floodFill(map: pipeMap, coloured: &colouredMap, xStart: startPos[0], yStart: startPos[1], xSize: xSize, ySize: ySize)
        } catch {
            print(error)
        }
    }
    
    static func partTwo() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 10)
            var pipeMap = [[String]]()
            
            // separate components of text into a 2D array (for loop used instead of reduce due to readability)
            for line in lines {
                pipeMap.append(line.map{String($0)})
            }
            
            // dimensions
            let ySize = pipeMap.count
            let xSize = pipeMap[0].count
            
            // get starting coordinate
            var startPos = [0,0]
            for (y, row) in pipeMap.indexed() {
                let search = row.firstIndex(of: "S")
                if (search != nil) {
                    startPos[0] = search!
                    startPos[1] = y
                    break
                }
            }
            
            // copy of the map to fill in
            var colouredMap = pipeMap
            
            // start flood fill
            try floodFillWithArea(map: pipeMap, coloured: &colouredMap, xStart: startPos[0], yStart: startPos[1], xSize: xSize, ySize: ySize)
        } catch {
            print(error)
        }
    }
    
    // credit geeksforgeeks.org
    private static func floodFill(map: [[String]], coloured: inout [[String]], xStart: Int, yStart: Int, xSize: Int, ySize: Int) throws {
        // variable init
        var queue = [(Int, Int, Int)]()
        let filled = "#"
        var highestStep = 0
        
        // append the position of starting pixel of the component
        queue.append((xStart, yStart, 0))
        
        // while the queue is not empty i.e. the whole component is not colored with the new color
        while queue.count > 0 {
            
            // dequeue the front node
            let currPixel = queue.removeFirst()
            
            // get current coords and object
            let posX = currPixel.0
            let posY = currPixel.1
            let stepCount = currPixel.2
            let prevObj = map[posY][posX]
            
            // traversal will meet in the middle - track steps as you go
            if stepCount > highestStep { highestStep = stepCount }
            
            // check if the adjacent pixels are valid
            if try isValid(map: coloured, xStart: posX + 1, yStart: posY, xSize: xSize, ySize: ySize, prevObj: prevObj, direction: .right) {
                // right
                coloured[posY][posX + 1] = filled
                queue.append((posX + 1, posY, stepCount + 1))
            }
            
            if try isValid(map: coloured, xStart: posX - 1, yStart: posY, xSize: xSize, ySize: ySize, prevObj: prevObj, direction: .left) {
                // left
                coloured[posY][posX - 1] = filled
                queue.append((posX - 1, posY, stepCount + 1))
            }
            
            if try isValid(map: coloured, xStart: posX, yStart: posY - 1, xSize: xSize, ySize: ySize, prevObj: prevObj, direction: .up) {
                // up
                coloured[posY - 1][posX] = filled
                queue.append((posX, posY - 1, stepCount + 1))
            }
            
            if try isValid(map: coloured, xStart: posX, yStart: posY + 1, xSize: xSize, ySize: ySize, prevObj: prevObj, direction: .down) {
                // down
                coloured[posY + 1][posX] = filled
                queue.append((posX, posY + 1, stepCount + 1))
            }
        }
        print(highestStep)
    }
    
    // credit geeksforgeeks.org
    private static func floodFillWithArea(map: [[String]], coloured: inout [[String]], xStart: Int, yStart: Int, xSize: Int, ySize: Int) throws {
        // variable init
        var queue = [(Int, Int)]()
        let filled = "#"
        var xCoords = [Int]()
        var yCoords = [Int]()
        
        // append the position of starting pixel of the component
        queue.append((xStart, yStart))
        xCoords.append(xStart)
        yCoords.append(yStart)
        
        // while the queue is not empty i.e. the whole component is not colored with the new color
        while queue.count > 0 {
            // dequeue the rear node
            let currPixel = queue.removeLast()
            
            // get current coords and object
            let posX = currPixel.0
            let posY = currPixel.1
            let prevObj = map[posY][posX]
            
            // check if the adjacent pixels are valid
            if try isValid(map: coloured, xStart: posX + 1, yStart: posY, xSize: xSize, ySize: ySize, prevObj: prevObj, direction: .right) {
                // right
                coloured[posY][posX + 1] = filled
                queue.append((posX + 1, posY))
                xCoords.append(posX + 1)
                yCoords.append(posY)
            }
            
            if try isValid(map: coloured, xStart: posX - 1, yStart: posY, xSize: xSize, ySize: ySize, prevObj: prevObj, direction: .left) {
                // left
                coloured[posY][posX - 1] = filled
                queue.append((posX - 1, posY))
                xCoords.append(posX - 1)
                yCoords.append(posY)
            }
            
            if try isValid(map: coloured, xStart: posX, yStart: posY - 1, xSize: xSize, ySize: ySize, prevObj: prevObj, direction: .up) {
                // up
                coloured[posY - 1][posX] = filled
                queue.append((posX, posY - 1))
                xCoords.append(posX)
                yCoords.append(posY - 1)
            }
            
            if try isValid(map: coloured, xStart: posX, yStart: posY + 1, xSize: xSize, ySize: ySize, prevObj: prevObj, direction: .down) {
                // down
                coloured[posY + 1][posX] = filled
                queue.append((posX, posY + 1))
                xCoords.append(posX)
                yCoords.append(posY + 1)
            }
        }
        
        // calculate internal points
        shoelace(xCoords: xCoords, yCoords: yCoords)
    }
    
    private static func isValid(map: [[String]], xStart: Int, yStart: Int, xSize: Int, ySize: Int, prevObj: String, direction: Direction?) throws -> Bool {
        // check if out of bounds
        if xStart < 0 || xStart >= xSize || yStart < 0 || yStart >= ySize { return false }
        
        let currObj = map[yStart][xStart]
        
        // checks for valid directions
        switch currObj {
        case "S":
            if prevObj == "S" { // start of search
                break
            } else { // end of search
                return false
            }
        case "|": // vertical pipe
            let validVertDir =
            ((prevObj == "|" || prevObj == "S") && (direction == .down || direction == .up)) ||
            ((prevObj == "L" || prevObj == "J") && direction == .up) ||
            ((prevObj == "7" || prevObj == "F") && direction == .down)
            if !validVertDir { return false }
        case "-": // horizontal pipe
            let validHorzDir =
            ((prevObj == "-" || prevObj == "S") && (direction == .left || direction == .right)) ||
            ((prevObj == "L" || prevObj == "F") && direction == .right) ||
            ((prevObj == "J" || prevObj == "7") && direction == .left)
            if !validHorzDir { return false }
        case "L": // N-E bend
            let validLDir =
            ((prevObj == "|" || prevObj == "F") && direction == .down) ||
            ((prevObj == "-" || prevObj == "J") && direction == .left) ||
            ((prevObj == "7" || prevObj == "S") && (direction == .down || direction == .left))
            if !validLDir { return false }
        case "J": // N-W bend
            let validJDir =
            ((prevObj == "|" || prevObj == "7") && direction == .down) ||
            ((prevObj == "-" || prevObj == "L") && direction == .right) ||
            ((prevObj == "S" || prevObj == "F") && (direction == .down || direction == .right))
            if !validJDir { return false }
        case "7": // S-W bend
            let valid7Dir =
            ((prevObj == "|" || prevObj == "J") && direction == .up) ||
            ((prevObj == "-" || prevObj == "F" ) && direction == .right) ||
            ((prevObj == "S" || prevObj == "L") && (direction == .up || direction == .right))
            if !valid7Dir { return false }
        case "F": // S-E bend
            let validFDir =
            ((prevObj == "|" || prevObj == "L") && direction == .up) ||
            ((prevObj == "-" || prevObj == "7") && direction == .left) ||
            ((prevObj == "S" || prevObj == "J") && (direction == .up || direction == .left))
            if !validFDir { return false }
        case ".": // ground
            return false
        case "#": // already checked
            return false
        default: // not accounted for
            throw Day10Error.invalidPipe(pipe: currObj)
        }
        return true
    }
    
    // credit geeksforgeeks.org
    private static func shoelace(xCoords: [Int], yCoords: [Int]) {
        var area = 0
        
        // shoelace formula - matrix sum the last point with the first, then sum as per normal
        var j = xCoords.count - 1
        
        for i in xCoords.indices {
            area += (xCoords[j] + xCoords[i]) * (yCoords[j] - yCoords[i])
            j = i
        }
        
        // solve for internal points
        let intPoints = (area / 2) - (xCoords.count / 2) + 1
        print(intPoints)
    }
    
    private enum Direction {
        case up, down, left, right
    }
    
    // custom error handling
    private enum Day10Error: Error {
        case invalidPipe(pipe: String)
    }
}
