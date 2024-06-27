//
//  GridView.swift
//  Set
//
//  Created by Yeliena Khaletska on 21.06.2024.
//

import UIKit

class GridView: UIView {

    var calculator = Grid(layout: .aspectRatio(5 / 8))
    var cardButtonTappedHandler: ((Int) -> Void)?
    var getCardHighlightColorForCard: ((Int) -> UIColor)?

    func add(_ cards: [Card?]) {

        self.subviews.forEach { $0.removeFromSuperview() }

        self.calculator.cellCount = cards.compactMap { $0 }.count
        self.calculator.frame = self.bounds

        for (index, card) in cards.enumerated() {
            guard let card = card,
                  let frame = self.calculator[index] else {
                continue
            }

            let cardButtonView = CardButton(frame: frame)
            cardButtonView.color = card.getColor()
            cardButtonView.number = card.number
            cardButtonView.shade = card.shade
            cardButtonView.shape = card.shape
            cardButtonView.ID = index
            
            if let getColor = self.getCardHighlightColorForCard {
                cardButtonView.highlight = getColor(index)
            } else {
                cardButtonView.highlight = .clear
            }

            addSubview(cardButtonView)

            cardButtonView.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
        }
    }

    @objc func cardButtonTapped(_ sender: CardButton) {
        cardButtonTappedHandler?(sender.ID)
    }

}

private extension Card {

    func getColor() -> UIColor {
        switch self.color {
        case .red:
            return .systemRed
        case .green:
            return .systemGreen
        case .purple:
            return .systemPurple
        }
    }

}
