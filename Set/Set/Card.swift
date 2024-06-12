//
//  Card.swift
//  Set
//
//  Created by Yeliena Khaletska on 12.06.2024.
//

import Foundation
import UIKit

struct Card {
    let color: Card.Color
    let shade: Card.Shade
    let shape: Card.Shape
    let number: Card.Number
    let content: NSAttributedString

    init(color: Card.Color, shade: Card.Shade, shape: Card.Shape, number: Card.Number) {
        self.color = color
        self.shade = shade
        self.shape = shape
        self.number = number

        var attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color.uicolor.withAlphaComponent(shade.alpha)
        ]

        if shade == .open {
            attributes[.strokeColor] = color.uicolor
            attributes[.strokeWidth] = -3.0
        }
        
        let string = String(repeating: shape.rawValue, count: number.rawValue)
        self.content = NSAttributedString(string: string, attributes: attributes)
    }

    enum Color: CaseIterable, Hashable {
        case red, green, blue

        var uicolor: UIColor {
            switch self {
            case .red:
                return .red
            case .green:
                return .green
            case .blue:
                return .blue
            }
        }
    }

    enum Shade: CaseIterable, Hashable {
        case open, striped, solid

        var alpha: CGFloat {
            switch self {
            case .open:
                return 0.0
            case .striped:
                return 0.15
            case .solid:
                return 1.0
            }
        }
    }

    enum Shape: String, CaseIterable, Hashable {
        case triangle = "▲"
        case circle = "●"
        case square = "■"
    }

    enum Number: Int, CaseIterable, Hashable {
        case one = 1, two, three
    }

}
