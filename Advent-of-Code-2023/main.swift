//
//  main.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 13/12/2023.
//

import Foundation

// custom error handling
enum AoC_Error: Error {
    case invalid_day(day: Int)
}

// TO UPDATE PER RUN
let day = 19
let p1 = false

do {
    let input = try InputReader.readFile(day: day)
    
    // start the timer
    let startTime = DispatchTime.now()
    var result: Int
    
    // execute the current day/part
    switch day {
    case 1:
        result = p1 ? Day_1.p1(input: input) : Day_1.p2(input: input)
    case 2:
        result = p1 ? try Day_2.p1(input: input) : try Day_2.p2(input: input)
    case 3:
        result = p1 ? Day_3.p1(input: input) : Day_3.p2(input: input)
    case 4:
        result = p1 ? Day_4.p1(input: input) : Day_4.p2(input: input)
    case 5:
        result = p1 ? Day_5.p1(input: input) : Day_5.p2(input: input)
    case 6:
        result = p1 ? Day_6.p1(input: input) : Day_6.p2(input: input)
    case 7:
        result = Day_7.p(input: input, partOne: p1)
    case 8:
        result = p1 ? try Day_8.p1(input: input) : try Day_8.p2(input: input)
    case 9:
        result = p1 ? Day_9.p1(input: input) : Day_9.p2(input: input)
    case 10:
        result = try Day_10.p(input: input, partOne: p1)
    case 11:
        result = p1 ? Day_11.p1(input: input) : Day_11.p2(input: input)
    case 12:
        result = try Day_12.p(input: input, partOne: p1)
    case 13:
        result = try Day_13.p(input: input, partOne: p1)
    case 14:
        result = p1 ? Day_14.p1(input: input) : Day_14.p2(input: input)
    case 15:
        result = p1 ? Day_15.p1(input: input) : try Day_15.p2(input: input)
    case 16:
        result = p1 ? try Day_16.p1(input: input) : try Day_16.p2(input: input)
    case 17:
        result = p1 ? Day_17.p1(input: input) : Day_17.p2(input: input)
    case 18:
        result = try Day_18.p(input: input, partOne: p1)
    case 19:
        result = p1 ? Day_19.p1(input: input) : Day_19.p2(input: input)
    default:
        throw AoC_Error.invalid_day(day: day)
    }
    
    // stop the timer
    let endTime = DispatchTime.now()
    
    // print result
    print(result)
    
    // calculate execution time
    let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let elapsedTimeMilliseconds = Double(elapsedTime) / 1_000_000
    let elapsedTimeSeconds = Double(elapsedTime) / 1_000_000_000
    
    // print execution time
    print("Execution time: \(elapsedTimeMilliseconds) ms (\(elapsedTimeSeconds) s)")
} catch {
    print(error)
}
