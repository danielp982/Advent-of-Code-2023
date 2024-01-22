//
//  Day_17.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 17/1/2024.
//

import Foundation

struct Day_17 {
    static func p1(input: [String]) -> Int {
        var heatMap = [[Int]]()
        
        // transform input to 2D array
        for line in input {
            heatMap.append(line.map{Int(String($0))!})
        }
        
        let result = aStarSearch(map: heatMap, xStart: 0, yStart: 0, xSize: heatMap[0].count, ySize: heatMap.count)
        return result
    }
    
    static func p2(input: [String]) -> Int {
        return 0
    }
    
    // credit geeks for geeks
    private static func aStarSearch(map: [[Int]], xStart: Int, yStart: Int, xSize: Int, ySize: Int) -> Int {
        // init the arrays needed for the search
        var visitedCoords = Set<String>()
        var tileDetails = Array(repeating: Array(repeating: Cell.init(), count: xSize), count: ySize)
        tileDetails[yStart][xStart].f = 0
        tileDetails[yStart][xStart].g = 0
        tileDetails[yStart][xStart].h = 0
        tileDetails[yStart][xStart].parent_x = xStart
        tileDetails[yStart][xStart].parent_y = yStart
        
        var coloured = map
        
        // initiate queue
        var queue = [(Int, Int, Direction?, Int)]() // (x, y, dir, count)
        queue.append((xStart, yStart, nil, 0))
        
        // while the queue is not empty
        while queue.count > 0 {
            
            // dequeue the front node
            let currNode = queue.removeFirst()
            
            // get current coords and object
            let currX = currNode.0
            let currY = currNode.1
            let currDir = currNode.2
            let currStepCount = currNode.3
            
            // record that we've been here
            visitedCoords.insert("\(currX),\(currY)")
            coloured[currY][currX] = 0
            
            // setup
            let nextPoints: [Direction : (Int, Int)] = [.right : (currX + 1, currY), .left : (currX - 1, currY), .up : (currX, currY - 1), .down : (currX, currY + 1)]
            
            for nextStep in nextPoints {
                // extract the variables
                let nextDir = nextStep.key
                let (posX, posY) = nextStep.value
                let isUTurn = currDir != nil ? nextDir.isOppositeOf(dir: currDir!) : false
                
                // check if the path out of bounds or if a UTurn
                guard posX >= 0 && posX < xSize && posY >= 0 && posY < ySize && !isUTurn else { continue }
                
                // check if arrived at destination
                if posX == xSize-1 && posY == ySize-1 {
                    tileDetails[posY][posX].parent_x = posX
                    tileDetails[posY][posX].parent_y = posY
                    tracePath()
                    
                    return 0 // TODO: return the correct value
                    
                } else {
                    // generate new values
                    let gNew = tileDetails[posY][posX].g + 1
                    let hNew = calculateH(posX: posX, posY: posY, stepCount: currStepCount)
                    let fNew = gNew + hNew
                    
                    // check if not in queue or if this path is better than the one we've explored
                    if (tileDetails[posY][posX].f == Int.max || tileDetails[posY][posX].f > fNew) {
                        // update the current step count
                        let newStepCount = nextDir == currDir ? currStepCount+1 : 0
                        queue.append((posX, posY, currDir, newStepCount))
                        
                        
                        // Update the details of this cell
                        tileDetails[posY][posX].f = fNew
                        tileDetails[posY][posX].g = gNew
                        tileDetails[posY][posX].h = hNew
                        tileDetails[posY][posX].parent_x = posX
                        tileDetails[posY][posX].parent_y = posY
                    }
                }
            }
        }
        
        // function to calculate heuristics
        func calculateH(posX: Int, posY: Int, stepCount: Int) -> Int {
            let distance = sqrt(pow(Double((posY - ySize-1)), 2) + pow(Double((posX - xSize-1)), 2))
            let heatLoss = map[posY][posX]
            let mustTurn = stepCount >= 3
            
            return mustTurn ? Int.max : Int(distance) * heatLoss
        }
        
        func tracePath() {
            print("The Path is ")
            var path = [(Int, Int)]()
            var row = ySize-1
            var col = xSize-1
         
            while !(tileDetails[row][col].parent_y == row && tileDetails[row][col].parent_x == col) {
                path.append((row, col))
                let temp_row = tileDetails[row][col].parent_y
                let temp_col = tileDetails[row][col].parent_x
                row = temp_row
                col = temp_col
            }
         
            path.append((row, col))
            while path.count > 0 {
                let p = path[0]
                path.removeFirst()
                 
                if p.0 == 2 || p.0 == 1 {
                    print("-> (\(p.0), \(p.1 - 1))")
                } else {
                    print("-> (\(p.0), \(p.1))")
                }
            }
        }
        
        return 0
    }
    
    struct Cell {
        var parent_x = -1
        var parent_y = -1
        var f = Int.max
        var g = 0
        var h = Int.max
    }
    
    private enum Direction {
        case up, down, left, right
        
        // custom function to assist with determining UTurns
        func isOppositeOf(dir: Direction) -> Bool {
            switch self {
            case .up:
                return dir == .down
            case .down:
                return dir == .up
            case .left:
                return dir == .right
            case .right:
                return dir == .left
            }
        }
    }
}
