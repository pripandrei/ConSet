//
//  Deck.swift
//  Set_Game
//
//  Created by Andrei Pripa on 9/18/22.
//

import Foundation

struct Deck {
    
    var cards = [CardSet]()
    
    init() {
        for shape in CardSet.Shape.allCases {
            for numberOfCard in CardSet.Number.allCases {
                for shading in CardSet.Shading.allCases {
                    for color in CardSet.Color.allCases {
                        cards.append(CardSet(shapeStyle: shape.rawValue, number: numberOfCard.rawValue, shadingStyle: shading.rawValue, colorStyle: color.rawValue))
                    }
                }
            }
        }
    }
    
    mutating func draw() -> CardSet? {
        if cards.count > 0 {
            let card = cards.remove(at: cards.count.arc4random)
            return card
        } else {
            return nil
        }
    }
}
