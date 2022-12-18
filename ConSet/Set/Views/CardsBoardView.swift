
import UIKit

class CardsBoardView: UIView {
    
    private var firstTimeDeal: Bool = true
    private var previousCountOfViews: Int = 12
    
    lazy var grid = Grid(layout: .aspectRatio(0.6777), frame: bounds)
    
    var numberOfCardsToBeDisplayed = 12 {
       didSet {
           grid.cellCount = numberOfCardsToBeDisplayed
       }
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
