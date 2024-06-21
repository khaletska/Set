//
//  CardButton.swift
//  Set
//
//  Created by Yeliena Khaletska on 21.06.2024.
//

import UIKit

final class CardButton: UIButton {

    var color: UIColor = .clear
    var shape: Card.Shape = .diamond

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()


        drawBezierPath()
    }

    private func drawBezierPath() {
        switch shape {
        case .diamond: drawPathForDiamond()
        case .oval: drawPathForOval()
        case .squiggle: drawPathForSquiggle()
        }
    }

    private func drawPathForDiamond() {
        let path = UIBezierPath()
        let diamondTop = CGPoint(
            x: self.bounds.midX - self.symbolWidth / 2,
            y: self.bounds.midY
        )
        path.move(to: diamondTop)

        let diamontRight = CGPoint(
            x: self.bounds.midX,
            y: self.bounds.midY + self.symbolHeight / 2
        )
        path.addLine(to: diamontRight)

        let diamondBottom = CGPoint(
            x: self.bounds.midX + self.symbolWidth / 2,
            y: self.bounds.midY
        )
        path.addLine(to: diamondBottom)

        let diamondLeft = CGPoint(
            x: self.bounds.midX,
            y: self.bounds.midY - self.symbolHeight / 2
        )
        path.addLine(to: diamondLeft)
        path.close()

        self.color.setFill()
        path.fill()
    }

    private func drawPathForOval() {
        let shapeTopLeftCorner = CGPoint(
            x: self.bounds.midX - self.symbolWidth / 2,
            y: self.bounds.midY - self.symbolHeight / 2
        )

        let roundedRect = CGRect(origin: shapeTopLeftCorner, size: self.symbolSize)
        let path = UIBezierPath(roundedRect: roundedRect, cornerRadius: self.symbolHeight / 2)

        self.color.setFill()
        path.fill()
    }

    private func drawPathForSquiggle() {
        let shapeBottomLeftCorner = CGPoint(
            x: self.bounds.midX - self.symbolWidth / 2,
            y: self.bounds.midY + self.symbolHeight / 2
        )

        let path = UIBezierPath()
        path.move(to: shapeBottomLeftCorner)

        let shapeTopRightCorner = CGPoint(
            x: self.bounds.midX + self.symbolWidth / 2,
            y: self.bounds.midY - self.symbolHeight / 2
        )
        let topLeftControlPoint = CGPoint(
            x: self.bounds.midX - self.symbolWidth / 2,
            y: self.bounds.midY - self.symbolHeight
        )
        let topRightControlPoint = CGPoint(
            x: self.bounds.midX + self.symbolWidth / 4,
            y: self.bounds.midY
        )
        path.addCurve(to: shapeTopRightCorner, controlPoint1: topLeftControlPoint, controlPoint2: topRightControlPoint)

        let bottomRightControlPoint = CGPoint(
            x: self.bounds.midX + self.symbolWidth / 2,
            y: self.bounds.midY + self.symbolHeight
        )
        let bottomLeftControlPoint = CGPoint(
            x: self.bounds.midX - self.symbolWidth / 4,
            y: self.bounds.midY
        )
        path.addCurve(to: shapeBottomLeftCorner, controlPoint1: bottomRightControlPoint, controlPoint2: bottomLeftControlPoint)
        path.close()

        self.color.setFill()
        path.fill()
    }

}

extension CardButton {

    private struct SizeRatio {
        static let widthRatio = 0.6
        static let heightRatio = 0.2
    }

    var symbolWidth: CGFloat {
        self.bounds.size.width * SizeRatio.widthRatio
    }

    var symbolHeight: CGFloat {
        self.bounds.size.height * SizeRatio.heightRatio
    }

    var symbolSize: CGSize {
        .init(width: self.symbolWidth, height: self.symbolHeight)
    }

}
