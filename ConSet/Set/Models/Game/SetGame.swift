//
//  SetGame.swift
//  Set_Game
//
//  Created by Andrei Pripa on 10/19/22.
//

import Foundation


struct SetGame {
    
    private(set) var selectedCards = [CardSet]()
    private(set) var cardsOnTable = 12
    
    private(set) var dateObserver = Date() {
        didSet {
            interval = dateObserver.timeIntervalSince(oldValue)
        }
    }
    
    var scoreCount = 0
    var playingCards = [CardSet]()
    
    var interval = Double() {
        didSet {
            switch interval
            {
                case 1...10: scoreCount += 5
                case 10...15: scoreCount += 4
                case 15...20: scoreCount += 3
                case 20...25: scoreCount += 2
                case 25...30: scoreCount += 1
                default: scoreCount += 0
            }
        }
    }
    
    mutating func shuffleCards() {
        playingCards.shuffle()
    }
    
    mutating func updateScoreCount()
    {
        let cardIsSet = playingCards.first { $0.cardIsSet == true || $0.cardIsSet == false }
        
        if let cardIsSet = cardIsSet {
            if cardIsSet.cardIsSet == true {
                scoreCount += 3
            } else if cardIsSet.cardIsSet == false  {
                scoreCount -= 5
            }
        }
    }
    
    mutating func manageThreeCardsButton() {
        updatePlayingCards()
        cardsOnTable += 3
    }
    
    mutating func updatePlayingCards() {
        
        if selectedCards.count == 3
        {
            for card in playingCards {
                if let cardIsSet = card.cardIsSet, cardIsSet {
                    let removedCard = playingCards.remove(at: cardsOnTable)
                    let cardIndex = playingCards.firstIndex(of: card)!
                    playingCards[cardIndex] = removedCard
                }
            }
            for index in playingCards.indices {
                if playingCards[index].cardIsSet == false {
                    playingCards[index].cardIsSet = nil
                    playingCards[index].isSelected = false
                }
            }
            selectedCards = []
        }
    }
    
    mutating func findAllSetsInDeck() -> Int {
        var numberOfSetsInDeck = 0
        
        for firstCard in 0..<playingCards.count {
            for secondCard in firstCard + 1..<playingCards.count {
                for thirdCard in secondCard + 1..<playingCards.count {
                    let threeCardsFromDeck = [playingCards[firstCard],playingCards[secondCard],playingCards[thirdCard]]
                    let isSet = checkIfSet(threeCardsFromDeck)
                    
                    if isSet {
                        numberOfSetsInDeck += 1
                    }
                    else {
                        continue
                    }
                }
            }
        }
        return numberOfSetsInDeck
    }
    
    mutating func findSetInCardsOnTable() -> [CardSet]? {
        for firstCard in 0..<cardsOnTable {
            for secondCard in firstCard + 1..<cardsOnTable {
                for thirdCard in secondCard + 1..<cardsOnTable {
                    
                    let threeCardsFromTable = [playingCards[firstCard],playingCards[secondCard],playingCards[thirdCard]]
                    let isSet = checkIfSet(threeCardsFromTable)
                    
                    if isSet {
                        return threeCardsFromTable
                    } else {
                        continue
                    }
                }
            }
        }
        return nil
    }
    
    mutating func checkIfSet(_ _cards: [CardSet]? = nil) -> Bool {
        let cards = _cards == nil ? selectedCards : _cards
        
        var shape = [Int]()
        var number = [Int]()
        var shading = [Int]()
        var color = [Int]()
        
        for card in cards!
        {
            shape.append(card.shapeStyle)
            number.append(card.number)
            shading.append(card.shadingStyle)
            color.append(card.colorStyle)
        }
        
        let properties = [shape,number,shading,color]

        let twoOfThreeReapeatedValues = properties.indices.filter { number in
            let feature = properties[number].map { ($0,1) }
            let timesFeaturesFromCardMatched = Dictionary(feature,uniquingKeysWith: +)
            return timesFeaturesFromCardMatched.count == 2
        }

        if twoOfThreeReapeatedValues.isEmpty {
            return true
        }
        return false
    }
    
    mutating func chooseCard(at index: Int) {
        
        let card = playingCards[index]
    
        updatePlayingCards()
        
        if !selectedCards.contains(card)
        {
            selectedCards.append(card)
            
            if let index = playingCards.firstIndex(of: card) {
                playingCards[index].isSelected = true
            }
        }
        else {
            selectedCards = selectedCards.filter { $0 != card }
            
            if let index = playingCards.firstIndex(of: card) {
                playingCards[index].isSelected = false
            }
            scoreCount -= 1
        }
        
        if selectedCards.count == 3
        {
                selectedCards.forEach { card in
                    guard let indexFromPlayingCards = playingCards.firstIndex(of: card) else {
                        return
                    }
                    playingCards[indexFromPlayingCards].cardIsSet = checkIfSet()
                }
            
            if checkIfSet() {
                dateObserver = Date()
            }
        }
        updateScoreCount()
    }
    
    init() {
        var deck = Deck()
        for _ in 0..<deck.cards.count {
            if let card = deck.draw() {
                playingCards += [card]
            }
        }
    }
}

