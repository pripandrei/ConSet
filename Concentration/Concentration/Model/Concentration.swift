//
//  Concentration.swift
//  Concentration
//
//  Created by Andrei Pripa on 9/21/22.
//

import Foundation

struct Concentration {
    
    var flippedCards = [Int]()
    private(set) var cards = [CardConcentration]()
    private(set) var flipCount = 0
    private(set) var scoreCount = 0
    private var scoreCountWasSubtracted = false
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for cardIndex in cards.indices {
                cards[cardIndex].isFaceUp = (cardIndex == newValue)
            }
        }
    }
    
    private mutating func checkIfChoosenCardsWereFlipped(_ indexes: Int...) {
        for card in indexes {
            if !flippedCards.contains(card) {
                flippedCards += [card]
            } else {
                scoreCount -= 1
                scoreCountWasSubtracted = true
            }
        }
    }
    

    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Opps, index of cards is out of range")
        if !cards[index].isMatched {
            flipCount += cards[index].isFaceUp ? 0 : 1
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    scoreCount += 2
                } else {
                    checkIfChoosenCardsWereFlipped(index, matchIndex)
                    if !scoreCountWasSubtracted {
                        scoreCount += TimerCustom.timerScoreCount()
                        TimerCustom.stemp1 = nil
                    }
                }
                cards[index].isFaceUp = true
            } else {
                if indexOfOneAndOnlyFaceUpCard == nil {
                    scoreCount += TimerCustom.timerScoreCount()
                }
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "At least 1 pair of cards needs to be present on creation")
        for _ in 1...numberOfPairsOfCards {
            let card = CardConcentration()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

