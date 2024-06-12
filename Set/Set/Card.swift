//
//  Card.swift
//  Set
//
//  Created by Yeliena Khaletska on 12.06.2024.
//

import Foundation
import UIKit

enum Color: CaseIterable {
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

enum Shade: CaseIterable {
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

enum Shape: String, CaseIterable {
    case triangle = "▲"
    case circle = "●"
    case square = "■"
}

enum Number: Int, CaseIterable {
    case one = 1, two, three
}

struct Card {
    let color: Color
    let shade: Shade
    let shape: Shape
    let number: Number
    let content: NSAttributedString

    init(color: Color, shade: Shade, shape: Shape, number: Number) {
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
}
