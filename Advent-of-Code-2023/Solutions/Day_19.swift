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
        var workflows: [String : [Step]] = [:]
        
        // build workflows
        for line in input {
            if line.isEmpty { break }
            
            // split components and build workflow dictionary
            let split = line.components(separatedBy: ["{", "}", ","]).filter{!$0.isEmpty}
            let key = split[0]
            var cat: String
            var comp: String
            var amount: Int
            var res: String
            var steps = [Step]()
            
            for items in split.dropFirst() {
                let detail = items.components(separatedBy: ["<", ">", ":"])
                cat = detail[0]
                
                if items.count >= 5 {
                    comp = String(items[items.index(items.startIndex, offsetBy: 1)])
                    amount = Int(detail[1])!
                    res = detail[2]
                    steps.append(Step(par: cat, comp: comp, num: amount, res: res))
                } else {
                    steps.append(Step(par: "", comp: "", num: 0, res: cat))
                }
            }
            workflows[key] = steps
        }
        
        // recursive solve
        let memoisedSolver = recursiveMemoize { (recursiveSolve, args: Args) in
            
            // extract the arguments
            let workflow = args.workflow
            let part = args.part
            
            for step in workflow {
                // extract the data
                let par = step.par
                let num = step.num
                let res = step.res
                
                // end if immediately accepted or rejected, or move onto the next workflow
                if par.isEmpty {
                    if res == "A" {
                        return solveA(part: part)
                    } else if res == "R" {
                        return 0
                    } else {
                        return recursiveSolve(Args(workflow: workflows[res]!, part: part))
                    }
                }
                
                // update the valid ranges
                let lb = part[par]!.lowerBound
                let ub = part[par]!.upperBound
                var newPartT = part
                var newPartF = part
                
                if step.comp == "<" {
                    return ltPartT() + ltPartF()
                } else {
                    return gtPartT() + gtPartF()
                }
                
                // helper function
                func ltPartT() -> Int {
                    if lb < num {
                        // passed, move onto next workflow
                        let newRange = lb...(num-1)
                        newPartT[par]! = newRange
                        if res == "A" {
                            return solveA(part: newPartT)
                        } else if res == "R" {
                            return 0
                        } else {
                            return recursiveSolve(Args(workflow: workflows[res]!, part: newPartT))
                        }
                    } else {
                        return 0
                    }
                }
                
                // helper function
                func ltPartF() -> Int {
                    if num < ub {
                        // failed, move onto next step
                        let newRange = num...ub
                        newPartF[par]! = newRange
                        return recursiveSolve(Args(workflow: Array(workflow.dropFirst()), part: newPartF))
                    } else {
                        return 0
                    }
                }
                
                // helper function
                func gtPartT() -> Int {
                    if num < ub {
                        // passed, move onto next workflow
                        let newRange = (num+1)...ub
                        newPartT[par]! = newRange
                        if res == "A" {
                            return solveA(part: newPartT)
                        } else if res == "R" {
                            return 0
                        } else {
                            return recursiveSolve(Args(workflow: workflows[res]!, part: newPartT))
                        }
                    } else {
                        return 0
                    }
                }
                
                // helper function
                func gtPartF() -> Int {
                    if lb < num {
                        // failed, move onto next step
                        let newRange = lb...num
                        newPartF[par]! = newRange
                        return recursiveSolve(Args(workflow: Array(workflow.dropFirst()), part: newPartF))
                    } else {
                        return 0
                    }
                }
                
                // return product of parts
                func solveA(part: [String : ClosedRange<Int>]) -> Int {
                    return part.reduce(into: 1, {$0 *= $1.value.count})
                }
            }
            // no further options to consider
            return 0
        }
        
        // run the solver
        let mainPart: [String : ClosedRange<Int>] = ["x" : 1...4000, "m" : 1...4000, "a" : 1...4000, "s" : 1...4000]
        return memoisedSolver(Args(workflow: workflows["in"]!, part: mainPart))
    }
    
    // credit Hacking with Swift
    private static func recursiveMemoize<Input: Hashable, Output>(_ function: @escaping ((Input) -> Output, Input) -> Output) -> (Input) -> Output {
        // our item cache
        var storage = [Input: Output]()
        
        // send back a new closure that does our calculation
        var memo: ((Input) -> Output)!
        memo = { input in
            if let cached = storage[input] {
                return cached
            }
            
            let result = function(memo, input)
            storage[input] = result
            return result
        }
        
        return memo
    }
    
    // step struct
    private struct Step: Hashable {
        var par: String
        var comp: String
        var num: Int
        var res: String
    }
    
    // struct for memoised function args
    private struct Args: Hashable {
        var workflow: [Step]
        var part: [String : ClosedRange<Int>]
    }
}
