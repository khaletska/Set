//
//  SetGame.swift
//  Set
//
//  Created by Yeliena Khaletska on 11.06.2024.
//

import Foundation

struct Card {

    let content = "💩"

}

final class SetGame {

    private var deck: Array<Card>
    private var shownCards: Array<Card>
    private var chosenCardsIndices: Array<Int>
    private var matchedCardsIndices: Array<Int>
    var canDrawCards: Bool {
        self.shownCards.count < 24
    }

    init() {
        self.deck = Array(repeating: Card(), count: 81)
        self.shownCards = []
        self.chosenCardsIndices = []
        self.matchedCardsIndices = []
    }

    func drawCards(_ amount: Int) {
        for _ in 0..<amount {
            drawOneCard()
        }
    }

    private func drawOneCard() {
        guard let lastCard = self.deck.popLast() else {
            assertionFailure("not implemented")
            return
        }

        self.shownCards.append(lastCard)
    }

    func touchCard(index: Int) {
        if self.chosenCardsIndices.contains(index) {
            chosenCardsIndices.removeAll { $0 == index }
        }
        else {
            self.chosenCardsIndices.append(index)
            if self.chosenCardsIndices.count == 3 {
                if matchCards() {
                    self.matchedCardsIndices.append(contentsOf: self.chosenCardsIndices)
                    self.shownCards.remove(atOffsets: IndexSet(self.chosenCardsIndices))
                    self.chosenCardsIndices = []
                    drawCards(3)
                }
            }
        }
    }

    private func matchCards() -> Bool {
        return true
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

}
