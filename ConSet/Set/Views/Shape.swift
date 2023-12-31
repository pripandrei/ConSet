

import UIKit

struct Shape {
    
    enum ShapeStyle {
        case diamond
        case oval
        case squiggle
    }
    
    var shapeStyle: ShapeStyle

    var ViewCardBounds: CGRect
    
    var cardShape: UIBezierPath {
        switch shapeStyle {
        case .diamond: return drawDiamond(ViewCardBounds)
        case .oval: return drawOval(ViewCardBounds)
        case .squiggle: return drawSquiggle(ViewCardBounds)
        }
    }
    
    private func drawDiamond(_ rect: CGRect) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.midX , y: rect.midY - (rect.midY / 4.0)))
        path.addLine(to: CGPoint(x: rect.midX + (rect.midX / 1.7), y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX , y: rect.midY + (rect.midY / 4.0)))
        path.addLine(to: CGPoint(x: rect.midX - (rect.midX / 1.7), y: rect.midY))
        path.close()
        path.lineWidth = 1.0
        
        return path
    }
    
    private func drawOval(_ rect: CGRect) -> UIBezierPath {

        let path = UIBezierPath(roundedRect: rect.insetBy(dx: rect.width / 5, dy: rect.height / 2.5) , cornerRadius: 15.0)
        path.lineWidth = 1.0
        
        return path
    }
    
    private func drawSquiggle(_ rect: CGRect) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.midX - (rect.midX / 2), y: rect.midY + (rect.midY / 18)))

        path.addQuadCurve(to: CGPoint(x: rect.midX - (rect.midX / 10), y: rect.midY - (rect.midY / 10)), controlPoint: CGPoint(x: rect.width / 4, y: CGFloat(rect.height / 2.5)))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX + (rect.midX / 3.5), y: rect.midY - (rect.midY / 6)), controlPoint: CGPoint(x: rect.midX + (rect.midX / 14), y: CGFloat(rect.height / 2.1)))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX + (rect.midX / 2.7), y:  CGFloat(rect.height / 2)), controlPoint: CGPoint(x: rect.width / 1.4, y: CGFloat(rect.height / 2.4)))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX - (rect.midX / 6.0), y:  CGFloat(rect.midY + (rect.midY / 11.0))), controlPoint: CGPoint(x: rect.width - (rect.width / 2.5), y: CGFloat(rect.height - (rect.height / 2.5))))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX - (rect.midX / 6.0), y:  CGFloat(rect.midY + (rect.midY / 11.0))), controlPoint: CGPoint(x: rect.width - (rect.width / 2.5), y: CGFloat(rect.height - (rect.height / 2.5))))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX - (rect.midX / 2.5), y: rect.midY + (rect.midY / 6)), controlPoint: CGPoint(x: rect.width / 3.0, y: CGFloat(rect.height / 1.88)))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX - (rect.midX / 2), y: rect.midY + (rect.midY / 18)), controlPoint: CGPoint(x: rect.width / 3.8, y: CGFloat(rect.height / 1.6)))

        path.lineWidth = 1.0
      
        return path
    }
    
    init(forCardWith bounds: CGRect, shapeStyle: ShapeStyle) {
        self.ViewCardBounds = bounds
        self.shapeStyle = shapeStyle
    }

}


// At current app stage not in use

//extension Shape {
//    private struct SizeRatio {
//        static let shapeCardSizeToBoundsSize: CGFloat = 0.3
//        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
//        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
//        static let cornerOffsetToCornerRadius: CGFloat = 0.33
//        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
//    }

//    private var cornerRadius: CGFloat {
//        return boundsFromViewCard.size.height * SizeRatio.cornerRadiusToBoundsHeight
//    }

//    private var cornerOffset: CGFloat {
//        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
//    }

//    private var cornerFontSize: CGFloat {
//        return boundsFromViewCard.size.height * SizeRatio.cornerFontSizeToBoundsHeight
//    }
//}


