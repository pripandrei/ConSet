//
//  CardsView.swift
//  Set_Game
//
//  Created by Andrei Pripa on 9/20/22.

import UIKit

@IBDesignable
class CardsView: UIView {
    
    enum Shading {
        case striped
        case solid
        case outline
    }
   
    var shapeStyle = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var colorStyle = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shadingStyle = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var number = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var isSet: Bool? { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isSelected = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var isFacedUp = false
    
    let cardsBoardView = CardsBoardView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func draw(_ rect: CGRect)
    {
        self.layer.masksToBounds = true
        if isSelected {
            self.layer.borderWidth = 1.1
            self.layer.borderColor = #colorLiteral(red: 0.5303892493, green: 0.5488235354, blue: 0.7337629795, alpha: 1).cgColor
        } else {
            self.layer.borderWidth = 0.0
        }
        
        if let isSet = isSet {
            if isSet == false {
                self.layer.borderWidth = 1.1
                self.layer.borderColor = #colorLiteral(red: 0.6018512845, green: 0.1524831653, blue: 0.3515754342, alpha: 1).cgColor
            }
            if isSet == true {
                self.layer.borderWidth = 1.1
                self.layer.borderColor = #colorLiteral(red: 0.2742731273, green: 0.483296752, blue: 0.1377799213, alpha: 1).cgColor
            }
        }
        
        if shapeStyle != 0
        {
            let drawShape = Shape(forCardWith: self.bounds, shapeStyle: shape!)
            let firstShapeOnCard = drawShape.cardShape
            var secondShapeOnCard: UIBezierPath?
            var thirdShapeOnCard: UIBezierPath?
            
            switch number {
            case 1: break
            case 2:
                secondShapeOnCard = firstShapeOnCard.copy() as? UIBezierPath
                firstShapeOnCard.apply(CGAffineTransform(translationX: 0.0, y: bounds.midY / 3.0))
                secondShapeOnCard!.apply(CGAffineTransform(translationX: 0.0, y: -bounds.midY / 3.0))
                firstShapeOnCard.append(secondShapeOnCard!)
            case 3:
                secondShapeOnCard = firstShapeOnCard.copy() as? UIBezierPath
                thirdShapeOnCard = firstShapeOnCard.copy() as? UIBezierPath
                firstShapeOnCard.apply(CGAffineTransform(translationX: 0.0, y: 0.0))
                secondShapeOnCard?.apply(CGAffineTransform(translationX: 0.0, y: -bounds.midY / 1.7))
                thirdShapeOnCard?.apply(CGAffineTransform(translationX: 0.0, y: bounds.midY / 1.7))
                firstShapeOnCard.append(secondShapeOnCard!)
                firstShapeOnCard.append(thirdShapeOnCard!)
            default: break
            }
            
            switch shading {
            case .striped:
                color?.setStroke();
                firstShapeOnCard.stroke();
            case .solid:
                color?.setFill();
                firstShapeOnCard.fill();
            case .outline:
                color?.setStroke();
                firstShapeOnCard.outline();
            default: break
            }
        }
    }
}

extension UIBezierPath {
    
    func outline() {
        
        self.addClip()
        
        var addition = 1.0
        
        var lineSpacing: CGFloat {
            get {
                addition += self.bounds.width / 25
                return CardsView().bounds.origin.x + addition
            }
        }

        func drawOutline() {
            self.move(to: CGPoint(x: lineSpacing, y: 0))
            self.addLine(to: CGPoint(x: lineSpacing, y: bounds.height))
        }
        
        for _ in 1...30 {
            drawOutline()
        }
       
        self.lineWidth = 1.0
        self.stroke()
    }
}

extension CardsView {
    
    private var shape: Shape.ShapeStyle? {
        switch shapeStyle {
        case 1: return .diamond
        case 2: return .oval
        case 3: return .squiggle
        default: return nil
        }
    }
    
    private var color: UIColor? {
        switch colorStyle {
        case 1: return #colorLiteral(red: 0.7601889372, green: 0.495136857, blue: 0.9892457128, alpha: 1)
        case 2: return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case 3: return #colorLiteral(red: 0, green: 0.5770805478, blue: 0.5444790125, alpha: 1)
        default: return nil
        }
    }
    
    private var shading: Shading? {
        switch shadingStyle {
        case 1: return .striped
        case 2: return .solid
        case 3: return .outline
        default: return nil
        }
    }

    /// Ratios that determine the card's size
    private struct SizeRatio {
        static let shapeCardSizeToBoundsSize: CGFloat = 0.3
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
        static let corrnerRadiusToFrameSize: CGFloat = 0.026
    }

    /// Corner radius
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }

    /// Corner offset
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }

    /// The font size for the corner text
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
 
     var cornerRadious: CGFloat {
         return (self.frame.height + self.frame.width) * SizeRatio.corrnerRadiusToFrameSize
     }

}

extension CGPoint {
    /// Get a new point with the given offset
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {

    /// Zoom rect by given factor
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }

    /// Get the left half of the rect
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }

    /// Get the right half of the rect
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
}

extension CGPoint {
    public static func +(lhs:CGPoint,rhs:CGPoint) -> CGPoint {
           return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
       }

    public static func +=(lhs:inout CGPoint, rhs:CGPoint) {
            lhs = lhs + rhs
        }
}
