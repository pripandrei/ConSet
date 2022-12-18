
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
    
    override func draw(_ rect: CGRect)
    {
        self.layer.masksToBounds = true
        if isSelected {
            self.layer.borderWidth = 1.1
            self.layer.borderColor = SetGraphicColor.cardSelectionColor.cgColor
        } else {
            self.layer.borderWidth = 0.0
        }
        
        if let isSet = isSet {
            if isSet == false {
                self.layer.borderWidth = 1.1
                self.layer.borderColor = SetGraphicColor.cardNotMatchedColor.cgColor
            }
            if isSet == true {
                self.layer.borderWidth = 1.1
                self.layer.borderColor = SetGraphicColor.setCardColor.cgColor
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
        case 1: return SetGraphicColor.CardFeaturesColor.purple
        case 2: return SetGraphicColor.CardFeaturesColor.red
        case 3: return SetGraphicColor.CardFeaturesColor.green
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
}

extension CGPoint {
    public static func +(lhs:CGPoint,rhs:CGPoint) -> CGPoint {
           return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
       }

    public static func +=(lhs:inout CGPoint, rhs:CGPoint) {
            lhs = lhs + rhs
        }
    
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
