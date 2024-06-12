//
//  SetGame.swift
//  Set
//
//  Created by Yeliena Khaletska on 11.06.2024.
//

import Foundation

final class SetGame {

    var canDrawCards: Bool {
        self.shownCards.count < 24
    }
    private var deck = Array<Card>()
    private var shownCards: Array<Card>
    private var chosenCardsIndices: Array<Int>
    private var matchedCardsIndices: Array<Int>

    init() {
        self.shownCards = []
        self.chosenCardsIndices = []
        self.matchedCardsIndices = []
        generateDeck()
    }

    func drawCards(_ amount: Int) {
        for _ in 0..<amount {
            drawOneCard()
        }
    }

    func touchCard(index: Int) {
        updateSelectedState(for: index)
        if self.chosenCardsIndices.count == 3, matchCards() {
            self.matchedCardsIndices.append(contentsOf: self.chosenCardsIndices)
            self.shownCards.remove(atOffsets: IndexSet(self.chosenCardsIndices))
            self.chosenCardsIndices = []
            drawCards(3)
        }
    }

    func getCard(for index: Int) -> Card? {
        guard index < shownCards.count else {
            return nil
        }

        return self.shownCards[index]
    }

    func isCardChosen(at index: Int) -> Bool {
        return chosenCardsIndices.firstIndex(of: index) != nil
    }

    private func generateDeck() {
        for color in Card.Color.allCases {
            for shade in Card.Shade.allCases {
                for shape in Card.Shape.allCases {
                    for number in Card.Number.allCases {
                        self.deck.append(Card(color: color, shade: shade, shape: shape, number: number))
                    }
                }
            }
        }

        self.deck.shuffle()
    }

    private func drawOneCard() {
        guard let lastCard = self.deck.popLast() else {
            assertionFailure("not implemented")
            return
        }

        self.shownCards.append(lastCard)
    }

    private func updateSelectedState(for cardIndex: Int) {
        if self.chosenCardsIndices.contains(cardIndex) {
            chosenCardsIndices.removeAll { $0 == cardIndex }
        }
        else {
            self.chosenCardsIndices.append(cardIndex)
        }
    }

    private func matchCards() -> Bool {
        guard self.chosenCardsIndices.count > 2 else {
            return false
        }

        let cards = self.chosenCardsIndices.map { self.shownCards[$0] }

        let cardsNumbers = cards.map { $0.number }
        let cardsShapes = cards.map { $0.shape }
        let cardsShades = cards.map { $0.shade }
        let cardsColors = cards.map { $0.color }

        let numberCondition = isMatching(cardsNumbers)
        let shapeCondition = isMatching(cardsShapes)
        let shadeCondition = isMatching(cardsShades)
        let colorCondition = isMatching(cardsColors)

        return numberCondition && shapeCondition && shadeCondition && colorCondition
    }

    private func isMatching<T: Hashable>(_ values: [T]) -> Bool {
        let equalCondition = values.dropFirst().allSatisfy { $0 == values.first }
        let differentCondition = Set(values).count == values.count

        return equalCondition || differentCondition
    }

}
