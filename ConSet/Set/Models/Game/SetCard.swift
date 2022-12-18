//
//  PlayingCards.swift
//  Set_Game
//
//  Created by Andrei Pripa on 10/28/22.
//

import Foundation

struct CardSet: CustomStringConvertible, Equatable {
    
    static func == (lhs: CardSet, rhs: CardSet) -> Bool {
        return lhs.shapeStyle == rhs.shapeStyle && lhs.number == rhs.number && lhs.shadingStyle == rhs.shadingStyle && lhs.colorStyle == rhs.colorStyle
    }
    
    private(set) var shapeStyle: Int
    private(set) var number: Int
    private(set) var shadingStyle: Int
    private(set) var colorStyle: Int
    
    var cardIsSet: Bool? = nil
    var isSelected: Bool = false
    
    enum Shape: Int, CaseIterable {
        case one = 1
        case two
        case three
    }

    enum Number: Int, CaseIterable {
        case one = 1
        case two
        case three
    }
    
    enum Shading: Int, CaseIterable {
        case one = 1
        case two
        case three
    }
    
    enum Color: Int, CaseIterable {
        case one = 1
        case two
        case three
    }
    
//    init(shapeStyle: Int, number: Int, shadingStyle: Int, colorStyle: Int) {
//        self.shapeStyle = shapeStyle
//        self.number = number
//        self.shadingStyle = shadingStyle
//        self.colorStyle = colorStyle
//    }
    
    var description: String { return "\(shapeStyle) \(number) \(shadingStyle) \(colorStyle)" }
}

