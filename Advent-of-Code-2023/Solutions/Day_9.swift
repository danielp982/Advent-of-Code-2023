//
//  Day_9.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 21/12/2023.
//

import Foundation

class Day_9 {
    static func p1(input: [String]) -> Int {
        // variable init
        var sum = 0
        
        // iterate over lines
        for line in input {
            
            let initialHistory = line.components(separatedBy: .whitespaces).compactMap{ Int($0) }
            var allHistories = [initialHistory]
            
            // work backwards
            repeat {
                var prevElement = -999
                // repeatedly get the distances between the arrays and add to allHistories
                let newHistory = allHistories.last!.reduce(into: [Int](), {
                    if prevElement != -999 {
                        $0.append($0.distance(from: prevElement, to: $1))
                    }
                    prevElement = $1
                })
                allHistories.append(newHistory)
            } while !allHistories.last!.allSatisfy{$0 == 0}
            
            // work forwards
            for history in allHistories.indices.reversed() {
                if allHistories[history].allSatisfy({$0 == 0}) {
                    allHistories[history].append(0)
                } else {
                    // sum of the previous reading and the sequence step
                    let newReading = allHistories[history].last! + allHistories[history+1].last!
                    allHistories[history].append(newReading)
                }
            }
            
            // sum the new readings
            sum += allHistories[0].last!
        }
        return sum
    }
    
    static func p2(input: [String]) -> Int {
        // variable init
        var sum = 0
        
        // iterate over lines
        for line in input {
            
            // reverse the initial array, most of the other calculations can proceed as before
            let initialHistory = line.components(separatedBy: .whitespaces).compactMap{ Int($0) }
            let reversedHistory: [Int] = Array(initialHistory.reversed())
            var allHistories = [reversedHistory]
            
            // work backwards
            repeat {
                var prevElement = -999
                // repeatedly get the distances between the arrays and add to allHistories
                let newHistory = allHistories.last!.reduce(into: [Int](), {
                    if prevElement != -999 {
                        $0.append($0.distance(from: $1, to: prevElement))
                    }
                    prevElement = $1
                })
                allHistories.append(newHistory)
            } while !allHistories.last!.allSatisfy{$0 == 0}
            
            // work forwards
            for history in allHistories.indices.reversed() {
                if allHistories[history].allSatisfy({$0 == 0}) {
                    allHistories[history].append(0)
                } else {
                    // difference of the previous reading and the sequence step
                    let newReading = allHistories[history].last! - allHistories[history+1].last!
                    allHistories[history].append(newReading)
                }
            }
            
            // sum the new readings
            sum += allHistories[0].last!
        }
        return sum
    }
}
