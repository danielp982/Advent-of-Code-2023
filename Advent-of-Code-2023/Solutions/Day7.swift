//
//  Day7.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 18/12/2023.
//

import Foundation
import Algorithms

class Day7 {
    static func part(part: Int) {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 7)
            
            // variable init
            var hands = [String]()
            var handBids: [String:Int] = [:]
            var sum = 0
            
            // format raw data
            for line in lines {
                
                let lineEl = line.components(separatedBy: " ")
                
                hands.append(lineEl[0])
                handBids[lineEl[0]] = Int(lineEl[1])!
            }
            
            // sort the hands using the custom function
            switch part {
            case 1:
                hands.sort(by: sortHand1)
            case 2:
                hands.sort(by: sortHand2)
            default:
                throw Day7Error.invalidPart(part: part)
            }
            hands.reverse() // easier to sum this way
            
            // sum up the score
            for (i, hand) in hands.indexed() {
                sum = sum + handBids[hand]! * (i+1)
            }
            
            print(sum)
        } catch {
            print(error)
        }
    }
    
    // sorting function for the cards (part one)
    private static func sortHand1(lhs: String, rhs: String) -> Bool {
        // init variables
        let handsComp = [lhs, rhs]
        var hsWinType: [WinType] = [.highCard, .highCard]
        let cardDic = ["2": Cards.two, "3": Cards.three, "4": Cards.four, "5": Cards.five, "6": Cards.six, "7": Cards.seven, "8": Cards.eight, "9": Cards.nine, "T": Cards.ten, "J": Cards.jack, "Q": Cards.queen, "K": Cards.king, "A": Cards.ace]
        
        for hs in 0...1 {
            
            // get individual counts of cards in hand
            let cardCount = handsComp[hs].reduce(into: [:], { $0[$1, default: 0] += 1 })
            
            // determine hand type
            if cardCount.count == 1 { hsWinType[hs] = .fiveOfAKind }
            else if cardCount.values.contains(4) { hsWinType[hs] = .fourOfAKind }
            else if cardCount.values.contains(3) && cardCount.count == 2 { hsWinType[hs] = .fullHouse }
            else if cardCount.values.contains(3) && cardCount.count == 3 { hsWinType[hs] = .threeOfAKind }
            else if cardCount.values.contains(2) && cardCount.count == 3 { hsWinType[hs] = .twoPair }
            else if cardCount.count == 4 { hsWinType[hs] = .onePair }
        }
        
        // return if already enough, otherwise sort by individual card
        if (hsWinType[0] == hsWinType[1]) {
            for card in 0...4 {
                // get individual cards
                let lhsCardIndex = handsComp[0].index(handsComp[0].startIndex, offsetBy: card)
                let rhsCardIndex = handsComp[1].index(handsComp[1].startIndex, offsetBy: card)
                let lhsCard = cardDic[String(handsComp[0][lhsCardIndex])]!
                let rhsCard = cardDic[String(handsComp[1][rhsCardIndex])]!
                
                // check for equal cards, then check for greater than / less than
                if lhsCard == rhsCard {
                    continue
                } else {
                    return lhsCard > rhsCard
                }
            }
            return true
        } else {
            return hsWinType[0] > hsWinType[1]
        }
    }
    
    // sorting function for the cards (part two)
    private static func sortHand2(lhs: String, rhs: String) -> Bool {
        // init variables
        let handsComp = [lhs, rhs]
        var hsWinType: [WinType] = [.highCard, .highCard]
        let cardDic = ["J": Cards.joker, "2": Cards.two, "3": Cards.three, "4": Cards.four, "5": Cards.five, "6": Cards.six, "7": Cards.seven, "8": Cards.eight, "9": Cards.nine, "T": Cards.ten, "Q": Cards.queen, "K": Cards.king, "A": Cards.ace]
        
        for hs in 0...1 {
            
            // get individual counts of cards in hand
            var cardCount = handsComp[hs].reduce(into: [:], { $0[$1, default: 0] += 1 })
            
            // deal with the jokers
            if (cardCount["J"] != nil) {
                let jValue = cardCount["J"]!
                cardCount.removeValue(forKey: "J")
                
                // account for "JJJJJ"
                if cardCount.isEmpty {
                    cardCount["A"] = jValue
                } else {
                    // get best card for joker to be
                    let maxValue = cardCount.max(by: {
                        if $0.value == $1.value {
                            cardDic[String($0.key)]! < cardDic[String($1.key)]!
                        } else {
                            $0.value < $1.value
                        }
                    })!
                    cardCount[maxValue.key]! += jValue
                }
            }
            
            // determine hand type
            if cardCount.count == 1 { hsWinType[hs] = .fiveOfAKind }
            else if cardCount.values.contains(4) { hsWinType[hs] = .fourOfAKind }
            else if cardCount.values.contains(3) && cardCount.count == 2 { hsWinType[hs] = .fullHouse }
            else if cardCount.values.contains(3) && cardCount.count == 3 { hsWinType[hs] = .threeOfAKind }
            else if cardCount.values.contains(2) && cardCount.count == 3 { hsWinType[hs] = .twoPair }
            else if cardCount.count == 4 { hsWinType[hs] = .onePair }
        }
        
        // return if already enough, otherwise sort by individual card
        if (hsWinType[0] == hsWinType[1]) {
            for card in 0...4 {
                // get individual cards
                let lhsCardIndex = handsComp[0].index(handsComp[0].startIndex, offsetBy: card)
                let rhsCardIndex = handsComp[1].index(handsComp[1].startIndex, offsetBy: card)
                let lhsCard = cardDic[String(handsComp[0][lhsCardIndex])]!
                let rhsCard = cardDic[String(handsComp[1][rhsCardIndex])]!
                
                // check for equal cards, then check for greater than / less than
                if lhsCard == rhsCard {
                    continue
                } else {
                    return lhsCard > rhsCard
                }
            }
            return true
        } else {
            return hsWinType[0] > hsWinType[1]
        }
    }
    
    private enum Cards: Comparable {
        case joker, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
    }
    
    private enum WinType: Comparable {
        case highCard, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind
    }
    
    // custom error handling
    private enum Day7Error: Error {
        case invalidPart(part: Int)
    }
}
