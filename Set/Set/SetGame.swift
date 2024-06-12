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
    private var deck: Array<Card>
    private var shownCards: Array<Card>
    private var chosenCardsIndices: Array<Int>
    private var matchedCardsIndices: Array<Int>

    init() {
        self.deck = Deck().deck
        self.shownCards = []
        self.chosenCardsIndices = []
        self.matchedCardsIndices = []
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
        guard self.chosenCardsIndices.count == 3 else {
            return false
        }

        let card1 = self.shownCards[chosenCardsIndices[0]]
        let card2 = self.shownCards[chosenCardsIndices[1]]
        let card3 = self.shownCards[chosenCardsIndices[2]]

        let numberCondition = isMatching(card1.number, card2.number, card3.number)
        let shapeCondition = isMatching(card1.shape, card2.shape, card3.shape)
        let shadingCondition = isMatching(card1.shade, card2.shade, card3.shade)
        let colorCondition = isMatching(card1.color, card2.color, card3.color)

        return numberCondition && shapeCondition && shadingCondition && colorCondition
    }

    private func isMatching<T: Equatable>(_ a: T, _ b: T, _ c: T) -> Bool {
        let equalCondition = a == b && a == c
        let differentCondition = a != b && b != c && a != c

        return equalCondition || differentCondition
    }

}
