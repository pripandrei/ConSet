//
//  Card.swift
//  Concentration
//
//  Created by Andrei Pripa on 9/21/22.
//

import Foundation

struct CardConcentration: Hashable, Equatable {
    
    var isFaceUp = false
    var isMatched = false
    private var identifire: Int = 0
    private static var identifireFactory = 0
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifire)
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.identifire == rhs.identifire 
    }
    
    private static func getUniqueIdentifire() -> Int {
        identifireFactory += 1
        return identifireFactory
    }
    
    init() {
        self.identifire = CardConcentration.getUniqueIdentifire()
    }
    
}







