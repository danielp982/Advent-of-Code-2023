//
//  InputReader.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 13/12/2023.
//

import Foundation

class InputReader {
    static func readFile(day: Int) throws -> [String] {
        let path = Bundle.main.path(forResource: "/Inputs/Day_\(day)_Input", ofType: "txt")!
        let data = try String(contentsOfFile: path, encoding: .utf8)
        return data.components(separatedBy: .newlines).dropLast()
    }
}
