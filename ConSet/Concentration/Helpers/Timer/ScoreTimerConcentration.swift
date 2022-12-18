
import Foundation

struct TimerCustom {
    static var stemp1: Date?
    private static var score = 0
    private static var interval: Double = 0.0
    
    static func timerScoreCount() -> Int {
        score = 0
        if stemp1 != nil {
            interval = Date().timeIntervalSince(stemp1!)
            if interval <= 1.5 {
                score += 1
            }
            stemp1 = nil
        } else {
            stemp1 = Date()
        }
        return score
    }
}
