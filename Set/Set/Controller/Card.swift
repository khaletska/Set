//
//  Card.swift
//  Set
//
//  Created by Yeliena Khaletska on 12.06.2024.
//

import Foundation

struct Card {
    let color: Color
    let shade: Shade
    let shape: Shape
    let number: Number
    let ID: Int

    enum Color: CaseIterable, Hashable {
        case red, green, purple
    }

    enum Shade: CaseIterable, Hashable {
        case open, striped, solid
    }

    enum Shape: CaseIterable, Hashable {
        case diamond, squiggle, oval
    }

    enum Number: CaseIterable, Hashable {
        case one, two, three
    }

}
