//
//  main.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 13/12/2023.
//

import Foundation

// start the timer
let startTime = DispatchTime.now()

// execute the current task
Day15.partTwo()

// stop the timer
let endTime = DispatchTime.now()

// calculate execution time
let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
let elapsedTimeMilliseconds = Double(elapsedTime) / 1_000_000
let elapsedTimeSeconds = Double(elapsedTime) / 1_000_000_000

// print execution time
print("Execution time: \(elapsedTimeMilliseconds) milliseconds (\(elapsedTimeSeconds) seconds)")
