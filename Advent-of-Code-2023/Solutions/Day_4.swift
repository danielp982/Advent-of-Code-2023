//
//  Day_4.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 15/12/2023.
//

import Foundation

struct Day_4 {
    static func p1(input: [String]) -> Int {
        
        // variable init
        var sum: Decimal = 0
        
        // iterate over lines
        for line in input {
            
            // separate components of the cards
            let card = line.components(separatedBy: [":", "|"])
            let winningNumbers = card[1].components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
            let myNumbers = card[2].components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
            
            // compare sets and return common numbers between both
            let totalMatches = Set(myNumbers).intersection(Set(winningNumbers))
            
            // calculate the winning score
            if totalMatches.count > 0 {
                sum += 1 * pow(2,totalMatches.count-1)
            }
        }
        return Int(truncating: sum as NSNumber)
    }
    
    static func p2(input: [String]) -> Int {
        // variable init
        var sum = 0
        var cardList: [String: Int] = [:]
        
        // iterate over lines
        for line in input {
            
            // separate components of the cards
            let card = line.components(separatedBy: [":", "|"])
            let cardNum = card[0].components(separatedBy: .decimalDigits.inverted).joined()
            let cardNumInt = Int(cardNum)!
            let winningNumbers = card[1].components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
            let myNumbers = card[2].components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
            
            // you'll always have minimum one card for this number
            cardList[cardNum] = (cardList[cardNum] ?? 0) + 1
            
            // compare sets and return common numbers between both
            let totalMatches = Set(myNumbers).intersection(Set(winningNumbers))
            guard totalMatches.count > 0 else { continue }
            
            // update the available cards based on the range of the winning cards
            for winningCard in cardNumInt+1...(cardNumInt+totalMatches.count) {
                let winningCardString = String(winningCard)
                cardList[winningCardString] = (cardList[winningCardString] ?? 0) + cardList[cardNum]!
            }
        }
        
        // sum the values in the dictionary
        sum = cardList.values.reduce(0, +)
        return sum
    }
}
