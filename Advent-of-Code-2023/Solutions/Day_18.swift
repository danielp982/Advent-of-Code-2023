//
//  Day_18.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 22/1/2024.
//

import Foundation

struct Day_18 {
    static func p(input: [String], partOne: Bool) throws -> Int {
        // get instructions
        var instructions: [(String, Int)]
        if partOne {
            instructions = getP1Instructions()
        } else {
            instructions = try getP2Instructions()
        }
        
        var coords = [(Int,Int)]()
        coords.append((0,0)) // starting coord
        var noOfCoords = 1
        
        // iterate through instructions
        for instruction in instructions {
            let (dir, amount) = instruction
            let lastCoord = coords.last!
            let coX = lastCoord.0
            let coY = lastCoord.1
            
            // append the coords that are dug out
            switch dir {
            case "U":
                coords.append((coX, coY-amount))
            case "D":
                coords.append((coX, coY+amount))
            case "L":
                coords.append((coX-amount, coY))
            case "R":
                coords.append((coX+amount, coY))
            default:
                throw Day_18_Error.invalid_direction(direction: dir)
            }
            
            // track the size of the perimeter
            noOfCoords += amount
        }
        
        // sum the area
        return shoelace(coords: coords.dropLast(), noOfCoords: noOfCoords)
        
        func getP1Instructions() -> [(String, Int)] {
            var instructions = [(String,Int)]()
            
            // p1 - components can be read directly from the input
            for line in input {
                let components = line.components(separatedBy: " ")
                let dir = components[0]
                let amount = Int(components[1])!
                
                instructions.append((dir,amount))
            }
            return instructions
        }
        
        func getP2Instructions() throws -> [(String, Int)] {
            var instructions = [(String,Int)]()
            
            // p2 - components are converted from hexademicals
            for line in input {
                // extract hex
                let components = line.components(separatedBy: " ")
                let hex = components[2].trimmingCharacters(in: .punctuationCharacters)
                
                // convert to instructions
                let amount = Int(hex.prefix(5), radix: 16)!
                var dir: String
                
                switch hex.last {
                case "0":
                    dir = "R"
                case "1":
                    dir = "D"
                case "2":
                    dir = "L"
                case "3":
                    dir = "U"
                default:
                    throw Day_18_Error.invalid_end_of_hex(hex: hex)
                }
                
                instructions.append((dir,amount))
            }
            return instructions
        }
    }
    
    // credit geeksforgeeks.org
    private static func shoelace(coords: [(Int, Int)], noOfCoords: Int) -> Int {
        var area = 0
        
        // shoelace formula - matrix sum the last point with the first, then sum as per normal
        var j = coords.count - 1
        
        for i in coords.indices {
            area += (coords[j].0 + coords[i].0) * (coords[j].1 - coords[i].1)
            j = i
        }
        
        // solve for internal and external points
        return (abs(area)-noOfCoords) / 2 + noOfCoords + 1
    }
    
    // custom error handling
    private enum Day_18_Error: Error {
        case invalid_direction(direction: String)
        case invalid_end_of_hex(hex: String)
    }
}
