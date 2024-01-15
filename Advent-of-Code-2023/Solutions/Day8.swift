//
//  Day8.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 21/12/2023.
//

import Foundation
import Algorithms

class Day8 {
    static func partOne() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 8)
            
            // variable init
            var status = 0
            var sum = 0
            var directions = [String]()
            var nodes: [String : [String]] = [:]
            
            // iterate over lines
            for line in lines {
                guard !line.isEmpty else { continue }
                
                switch status {
                case 0:
                    directions = line.map{String($0)}
                    status += 1
                case 1:
                    let points = line.components(separatedBy: .alphanumerics.inverted).filter{!$0.isEmpty}
                    nodes[points[0]] = points.suffix(2)
                default:
                    throw Day8Error.invalidStatus(status: status)
                }
            }
            
            // starting position
            var position = "AAA"
            
            // repeatedly loop through directions until ZZZ is found
            for direction in directions.cycled() {
                let currentNode = nodes[position]!
                switch direction {
                case "L":
                    position = currentNode[0]
                case "R":
                    position = currentNode[1]
                default:
                    throw Day8Error.invalidDirection(direction: direction)
                }
                sum += 1
                if position == "ZZZ" { break }
            }
            
            print(sum)
        } catch {
            print(error)
        }
    }
    
    static func partTwo() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 8)
            
            // variable init
            var status = 0
            var sums: [Int]
            var directions = [String]()
            var nodes: [String : [String]] = [:]
            
            // iterate over lines
            for line in lines {
                guard !line.isEmpty else { continue }
                
                switch status {
                case 0:
                    directions = line.map{String($0)}
                    status += 1
                case 1:
                    let points = line.components(separatedBy: .alphanumerics.inverted).filter{!$0.isEmpty}
                    nodes[points[0]] = points.suffix(2)
                default:
                    throw Day8Error.invalidStatus(status: status)
                }
            }
            
            // starting positions
            var positions = nodes.filter{$0.key.hasSuffix("A")}.map{$0.key}
            sums = [Int](repeating: 0, count: positions.count)
            
            // repeatedly loop through directions until suffix of Z is found for each item
            for i in positions.indices {
                for direction in directions.cycled() {
                    let currentNode = nodes[positions[i]]!
                    switch direction {
                    case "L":
                        positions[i] = currentNode[0]
                    case "R":
                        positions[i] = currentNode[1]
                    default:
                        throw Day8Error.invalidDirection(direction: direction)
                    }
                    sums[i] += 1
                    if positions[i].hasSuffix("Z") { break }
                }
            }
            
            // get lcm of each route
            let sumsInit = sums[0]
            let total = sums.dropFirst().reduce(sumsInit, lcm)
            
            print(total)
        } catch {
            print(error)
        }
    }
    
    // least common multiple
    private static func lcm(x: Int, y: Int) -> Int {
        return (x / gcd(x: x, y: y)) * y
    }
    
    // greatest common denominator
    private static func gcd(x: Int, y: Int) -> Int {
        if y == 0 {
            return x
        }
        return gcd(x: y, y: x % y)
    }
    
    // custom error handling
    private enum Day8Error: Error {
        case invalidDirection(direction: String)
        case invalidStatus(status: Int)
    }
}
