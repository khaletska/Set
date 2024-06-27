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
    var number: Card.Number = .one
    var shade: Card.Shade = .open
    var highlight: UIColor = .clear
    var ID: Int = -1

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        highlight.setStroke()
        roundedRect.lineWidth = 3
        roundedRect.stroke()
        
        drawBezierPath()
    }

    private func drawBezierPath() {
        switch shape {
        case .diamond: drawPathForDiamond()
        case .oval: drawPathForOval()
        case .squiggle: drawPathForSquiggle()
        }
    }

    private func drawVerticalStripes() {
        let start = self.bounds.minX
        let end = self.bounds.maxX
        let stripeSpacing = self.symbolWidth * 0.06

        var x = start
        while x <= end {
            let stripePath = UIBezierPath()
            stripePath.move(to: CGPoint(x: x, y: self.bounds.minY))
            stripePath.addLine(to: CGPoint(x: x, y: self.bounds.maxY))
            stripePath.lineWidth = self.symbolWidth / 40
            self.color.setStroke()
            stripePath.stroke()

            x += stripeSpacing
        }
    }

    private func drawPathForDiamond() {
        let offsets = getVerticalCenterOffsets(for: self.number)
        let path = UIBezierPath()
        for offset in offsets {
            let diamondLeft = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: 0, dy: self.symbolHeight / 2 + offset)
            path.move(to: diamondLeft)

            let diamondBottom = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: self.symbolWidth / 2, dy: self.symbolHeight + offset)
            path.addLine(to: diamondBottom)

            let diamondRight = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: self.symbolWidth, dy: self.symbolHeight / 2 + offset)
            path.addLine(to: diamondRight)

            let diamondTop = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: self.symbolWidth / 2, dy: offset)
            path.addLine(to: diamondTop)
            path.close()
        }

        applyShade(for: path)
    }

    private func drawPathForOval() {
        let offsets = getVerticalCenterOffsets(for: self.number)
        let path = UIBezierPath()
        for offset in offsets {
            let shapeTopLeftCorner = self.leftTopCornerOfCentralSymbol.offsetBy(dx: 0, dy: offset)
            let roundedRect = CGRect(origin: shapeTopLeftCorner, size: self.symbolSize)
            path.append(UIBezierPath(roundedRect: roundedRect, cornerRadius: self.symbolHeight / 2))
        }

        applyShade(for: path)
    }

    private func drawPathForSquiggle() {
        let offsets = getVerticalCenterOffsets(for: self.number)
        let path = UIBezierPath()

        for offset in offsets {
            let shapeBottomLeftCorner = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: 0, dy: self.symbolHeight + offset)
            path.move(to: shapeBottomLeftCorner)

            let shapeTopRightCorner = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: self.symbolWidth, dy: offset)
            let topLeftControlPoint = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: 0, dy: -self.symbolHeight / 2 + offset)
            let topRightControlPoint = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: self.symbolWidth * 3 / 4, dy: self.symbolHeight / 2 + offset)
            path.addCurve(to: shapeTopRightCorner, controlPoint1: topLeftControlPoint, controlPoint2: topRightControlPoint)

            let bottomRightControlPoint = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: self.symbolWidth, dy: self.symbolHeight * 1.5 + offset)
            let bottomLeftControlPoint = self.leftTopCornerOfCentralSymbol
                .offsetBy(dx: self.symbolWidth * 1 / 4, dy: symbolHeight / 2 + offset)
            path.addCurve(to: shapeBottomLeftCorner, controlPoint1: bottomRightControlPoint, controlPoint2: bottomLeftControlPoint)
            path.close()
        }

        applyShade(for: path)
    }

    private func applyShade(for path: UIBezierPath) {
        switch self.shade {
        case .open:
            self.color.setStroke()
            path.stroke()
        case .striped:
            path.addClip()
            drawVerticalStripes()
            self.color.setStroke()
            path.stroke()
        case .solid:
            self.color.setFill()
            path.fill()
        }
    }
}

extension CardButton {

    private struct SizeRatio {
        static let widthRatio = 0.6
        static let heightRatio = 0.23
        static let offsetRatio = 0.15
        static let cornerRadiusRatio = 0.1
    }

    private var symbolWidth: CGFloat {
        self.bounds.size.width * SizeRatio.widthRatio
    }

    private var symbolHeight: CGFloat {
        self.bounds.size.height * SizeRatio.heightRatio
    }

    private var verticalOffsetMin: CGFloat {
        self.bounds.size.height * SizeRatio.offsetRatio
    }

    private var symbolSize: CGSize {
        .init(width: self.symbolWidth, height: self.symbolHeight)
    }

    private var cornerRadius: CGFloat {
        self.bounds.size.width * SizeRatio.cornerRadiusRatio
    }

    private var leftTopCornerOfCentralSymbol: CGPoint {
        .init(x: self.bounds.midX, y: self.bounds.midY)
        .offsetBy(dx: -self.symbolWidth / 2, dy: -self.symbolHeight / 2)
    }

    private func getVerticalCenterOffsets(for number: Card.Number) -> Array<CGFloat> {
        switch number {
        case .one: [0 * self.verticalOffsetMin]
        case .two: [-1 * self.verticalOffsetMin, 1 * self.verticalOffsetMin]
        case .three: [-2 * self.verticalOffsetMin, 0 * self.verticalOffsetMin, 2 * self.verticalOffsetMin]
        }
    }

}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        CGPoint(x: x + dx, y: y + dy)
    }
}
