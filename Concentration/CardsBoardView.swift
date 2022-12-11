//
//  CardBoard.swift
//  Set_Game
//
//  Created by Andrei Pripa on 9/18/22.
//

import UIKit

class CardsBoardView: UIView {
    
    
    private var firstTimeDeal: Bool = true
    
    private var previousCountOfViews = 12
    
    lazy var grid = Grid(layout: .aspectRatio(0.6777), frame: bounds)
    
    var numberOfCardsToBeDisplayed = 12 {
       didSet {
           grid.cellCount = numberOfCardsToBeDisplayed
       }
    }
    
    private var subviewToCoverShape: UIView {
        let subViee = UIView()
        subViee.backgroundColor = UIColor.white
        subViee.layer.masksToBounds = true
        subViee.layer.cornerRadius = CardsView().cornerRadious
        return subViee
    }
    
    override func draw(_ rect: CGRect) {}
    
    override func layoutIfNeeded() {
        grid.frame = bounds
        grid.cellCount = numberOfCardsToBeDisplayed
    }
    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        layoutIfNeeded()
        grid.frame = bounds
        grid.cellCount = numberOfCardsToBeDisplayed
    }
}

extension CardsBoardView {
    private struct SizeRatio {
        static let corrnerRadiusToFrameSize: CGFloat = 0.007
    }
    
    var cornerRadious: CGFloat {
        return (self.frame.height + self.frame.width) * SizeRatio.corrnerRadiusToFrameSize
    }
}
