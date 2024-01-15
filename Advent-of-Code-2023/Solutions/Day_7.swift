//
//  Day_7.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 18/12/2023.
//

import Foundation
import Algorithms

class Day_7 {
    static func p(input: [String], partTwo: Bool) -> Int {
        // variable init
        var hands = [String]()
        var handBids: [String:Int] = [:]
        var sum = 0
        
        // format raw data
        for line in input {
            
            let lineEl = line.components(separatedBy: " ")
            
            hands.append(lineEl[0])
            handBids[lineEl[0]] = Int(lineEl[1])!
        }
        
        // sort the hands using the custom function
        hands.sort(by: {sortHand(lhs: $0, rhs: $1, partTwo: partTwo)} )
        hands.reverse() // easier to sum this way
        
        // sum up the score
        for (i, hand) in hands.indexed() {
            sum = sum + handBids[hand]! * (i+1)
        }
        
        return sum
    }
    
    // sorting function for the cards
    private static func sortHand(lhs: String, rhs: String, partTwo: Bool) -> Bool {
        // init variables
        let handsComp = [lhs, rhs]
        var hsWinType: [WinType] = [.highCard, .highCard]
        var cardDic: [String : Cards] = ["2": .two, "3": .three, "4": .four, "5": .five, "6": .six, "7": .seven, "8": .eight, "9": .nine, "T": .ten, "Q": .queen, "K": .king, "A": .ace]
        if partTwo { cardDic["J"] = .joker } else { cardDic["J"] = .jack }
        
        for hs in 0...1 {
            
            // get individual counts of cards in hand
            var cardCount = handsComp[hs].reduce(into: [:], { $0[$1, default: 0] += 1 })
            
            // deal with the jokers in part two
            if partTwo {
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
}
