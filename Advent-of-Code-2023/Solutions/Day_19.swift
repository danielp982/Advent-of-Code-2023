//
//  Day_19.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 22/1/2024.
//

import Foundation
import Algorithms

struct Day_19 {
    static func p1(input: [String]) -> Int {
        var onWorkflow = true
        var workflows: [String : [(String, String, Int, String)]] = [:]
        var parts = [[String : Int]]()
        var acceptedParts = [[String : Int]]()
        
        // build workflows and parts
        for line in input {
            if line.isEmpty {
                onWorkflow = false
                continue
            }
            
            if onWorkflow {
                // split components and build workflow dictionary
                let split = line.components(separatedBy: ["{", "}", ","]).filter{!$0.isEmpty}
                let key = split[0]
                var cat: String
                var comp: String
                var amount: Int
                var res: String
                var steps = [(String, String, Int, String)]()
                
                for items in split.dropFirst() {
                    let detail = items.components(separatedBy: ["<", ">", ":"])
                    cat = detail[0]
                    
                    if items.count >= 5 {
                        comp = String(items[items.index(items.startIndex, offsetBy: 1)])
                        amount = Int(detail[1])!
                        res = detail[2]
                        steps.append((cat, comp, amount, res))
                    } else {
                        steps.append(("", "", 0, cat))
                    }
                }
                
                workflows[key] = steps
            } else {
                // split components and build part dictionary
                let split = line.components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
                var part: [String : Int] = [:]
                for (i, key) in ["x", "m", "a", "s"].indexed() {
                    part[key] = Int(split[i])!
                }
                parts.append(part)
            }
        }
        
        // execute the workflow
        for part in parts {
            var currFlow = "in"
            
            repeat {
               let steps = workflows[currFlow]
                for step in steps! {
                    // extract the data
                    let par = step.0
                    let num = step.2
                    let res = step.3
                    var check: Bool
                    
                    // end if accepted or rejected, or move onto the next workflow
                    if par.isEmpty {
                        if res == "A" {
                            acceptedParts.append(part)
                        }
                        currFlow = res
                        break
                    }

                    // compare the part
                    if step.1 == "<" {
                        check = part[par]! < num
                    } else {
                        check = part[par]! > num
                    }
                    
                    // move onto the next workflow, else the next step
                    if check {
                        if res == "A" {
                            acceptedParts.append(part)
                        }
                        currFlow = res
                        break
                    }
                }
            } while currFlow != "A" && currFlow != "R"
        }
        
        // sum all the accepted parts
        var sum = 0
        for part in acceptedParts {
            sum += part.reduce(into: 0, {$0 += $1.value})
        }
        
        return sum
    }
    
    static func p2(input: [String]) -> Int {
        return 0
    }
}
