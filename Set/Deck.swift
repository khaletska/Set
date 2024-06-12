//
//  Deck.swift
//  Set
//
//  Created by Yeliena Khaletska on 12.06.2024.
//

import Foundation

struct Deck {
    let deck: Array<Card> = {
        var cards: Array<Card> = []

        for color in Color.allCases {
            for shade in Shade.allCases {
                for shape in Shape.allCases {
                    for number in Number.allCases {
                        cards.append(Card(color: color, shade: shade, shape: shape, number: number))
                    }
                }
            }
        }
        
        return cards.shuffled()
    }()
}
