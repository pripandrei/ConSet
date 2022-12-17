//
//  Score.swift
//  Set_Game
//
//  Created by Andrei Pripa on 10/5/22.
//

import Foundation

struct customTimer {
    static var stemp1: Date?
    private static var score = 0
    private static var interval: Double = 0.0
    
    static func timerScoreCount() -> Int {
        score = 0
        if stemp1 != nil {
            interval = Date().timeIntervalSince(stemp1!)
            switch interval
            {
                case _ where interval < 10: score += 5
                case 11...15: score += 4
                case 16...20: score += 3
                case 21...25: score += 2
                case 26...30: score += 1
                default: score += 0
            }
            stemp1 = nil
        } else {
            stemp1 = Date()
        }
        return score
    }
}
