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
    var number: Int = 1

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()

        drawBezierPath()
    }

    private func drawBezierPath() {
        let offsets = getCenterOffsets(for: self.number)
        switch shape {
        case .diamond:
            for offset in offsets {
                drawPathForDiamond(from: self.cardCenter.offsetBy(dx: offset[0], dy: offset[1]))
            }
        case .oval: 
            for offset in offsets {
                drawPathForOval(from: self.cardCenter.offsetBy(dx: offset[0], dy: offset[1]))
            }
        case .squiggle: 
            for offset in offsets {
                drawPathForSquiggle(from: self.cardCenter.offsetBy(dx: offset[0], dy: offset[1]))
            }
        }
    }

    private func drawPathForDiamond(from center: CGPoint) {
        let path = UIBezierPath()
        let diamondLeft = center.offsetBy(dx: -self.symbolWidth / 2, dy: 0)
        path.move(to: diamondLeft)

        let diamontTop = center.offsetBy(dx: 0, dy: self.symbolHeight / 2)
        path.addLine(to: diamontTop)

        let diamondRight = center.offsetBy(dx: self.symbolWidth / 2, dy: 0)
        path.addLine(to: diamondRight)

        let diamondTop = center.offsetBy(dx: 0, dy: -self.symbolHeight / 2)
        path.addLine(to: diamondTop)
        path.close()

        self.color.setFill()
        path.fill()
    }

    private func drawPathForOval(from center: CGPoint) {
        let shapeTopLeftCorner = center.offsetBy(dx: -self.symbolWidth / 2, dy: -self.symbolHeight / 2)
        let roundedRect = CGRect(origin: shapeTopLeftCorner, size: self.symbolSize)
        let path = UIBezierPath(roundedRect: roundedRect, cornerRadius: self.symbolHeight / 2)

        self.color.setFill()
        path.fill()
    }

    private func drawPathForSquiggle(from center: CGPoint) {
        let shapeBottomLeftCorner = center.offsetBy(dx: -self.symbolWidth / 2, dy: self.symbolHeight / 2)

        let path = UIBezierPath()
        path.move(to: shapeBottomLeftCorner)

        let shapeTopRightCorner = center.offsetBy(dx: self.symbolWidth / 2, dy: -self.symbolHeight / 2)
        let topLeftControlPoint = center.offsetBy(dx: -self.symbolWidth / 2, dy: -self.symbolHeight)
        let topRightControlPoint = center.offsetBy(dx: self.symbolWidth / 4, dy: 0)
        path.addCurve(to: shapeTopRightCorner, controlPoint1: topLeftControlPoint, controlPoint2: topRightControlPoint)

        let bottomRightControlPoint = center.offsetBy(dx: self.symbolWidth / 2, dy: self.symbolHeight)
        let bottomLeftControlPoint = center.offsetBy(dx: -self.symbolWidth / 4, dy: 0)
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

    private var symbolWidth: CGFloat {
        self.bounds.size.width * SizeRatio.widthRatio
    }

    private var symbolHeight: CGFloat {
        self.bounds.size.height * SizeRatio.heightRatio
    }

    private var symbolSize: CGSize {
        .init(width: self.symbolWidth, height: self.symbolHeight)
    }

    private var cardCenter: CGPoint {
        .init(x: self.bounds.midX, y: self.bounds.midY)
    }

    private func getCenterOffsets(for number: Int) -> Array<Array<CGFloat>> {
        let centerOffsetsForSymbols: Array<Array<Array<CGFloat>>> = [[[0, 0]], // case one symbol
                                                                     [[0, -12.5], [0, 12.5]], // case two symbols
                                                                     [[0, -25], [0, 0], [0, 25]]] // case three symbols

        return centerOffsetsForSymbols[number-1]
    }

}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
