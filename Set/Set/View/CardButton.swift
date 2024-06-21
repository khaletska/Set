//
//  CardButton.swift
//  Set
//
//  Created by Yeliena Khaletska on 21.06.2024.
//

import UIKit

class CardButton: UIButton {

    var color: UIColor = .clear
    var shape: Card.Shape = .diamond

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()


        drawBezierPath(for: shape, with: color)
    }

    private func drawBezierPath(for shape: Card.Shape,
                               with color: UIColor) {

        switch shape {
        case .diamond:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.midX - self.symbolWidth / 2, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + self.symbolHeight / 2))
            path.addLine(to: CGPoint(x: bounds.midX + self.symbolWidth / 2, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY - self.symbolHeight / 2))
            path.close()
            self.color.setFill()
            path.fill()
        case .oval:
            let path = UIBezierPath(roundedRect:
                                        CGRect(
                                            x: bounds.midX - self.symbolWidth / 2,
                                            y: bounds.midY - self.symbolHeight / 2,
                                            width: self.symbolWidth,
                                            height: self.symbolHeight),
                                    cornerRadius: self.symbolHeight / 2)
            self.color.setFill()
            path.fill()
        case .squiggle:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.midX - self.symbolWidth / 2, y: bounds.midY + self.symbolHeight / 2))
            path.addCurve(to: CGPoint(x: bounds.midX + self.symbolWidth / 2, y: bounds.midY - self.symbolHeight / 2),
                          controlPoint1: CGPoint(x: bounds.midX - self.symbolWidth / 2, y: bounds.midY - self.symbolHeight),
                          controlPoint2: CGPoint(x: bounds.midX + self.symbolWidth / 4, y: bounds.midY))
            path.addCurve(to: CGPoint(x: bounds.midX - self.symbolWidth / 2, y: bounds.midY + self.symbolHeight / 2),
                          controlPoint1: CGPoint(x: bounds.midX + self.symbolWidth / 2, y: bounds.midY + self.symbolHeight),
                          controlPoint2: CGPoint(x: bounds.midX - self.symbolWidth / 4, y: bounds.midY))
            path.close()
            self.color.setFill()
            path.fill()

        }
    }

}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension CardButton {

    private struct SizeRatio {
        static let widthRatio = 0.6
        static let heightRatio = 0.2
    }

    public var symbolWidth: CGFloat {
        bounds.size.width * SizeRatio.widthRatio
    }

    public var symbolHeight: CGFloat {
        bounds.size.height * SizeRatio.heightRatio
    }
}
