//
//  SetGame.swift
//  Set
//
//  Created by Yeliena Khaletska on 11.06.2024.
//

import Foundation

enum CardState {
    case chosen, matched, unmatched
}

final class SetGame {

    var canDrawCards: Bool {
        !self.deck.isEmpty
    }
    var delegate: SetGameDelegate!
    var shownCards: Array<Card?> = .init(repeating: nil, count: 12)
    private var deck: Array<Card> = SetGame.generateDeck()
    private var chosenCardsIndices: Array<Int> = []
    private var matchedCardsIndices: Array<Int> = []
    private var unmatchedCardsIndices: Array<Int> = []
    private(set) var score: Int = 0

    func touchCard(indexOnBoard: Int) {
        guard let ID = getCardID(by: indexOnBoard) else {
            return
        }

        guard !self.matchedCardsIndices.contains(ID) else {
            return
        }

        updateSelectedState(for: ID)
        if !self.matchedCardsIndices.isEmpty {
            removeMatchedCards()

            if !self.deck.isEmpty {
                dealCards(3)
            }
        }

        deselectUnmatchedCardsIfNeeded()
        updateMatchingState(for: ID)
        updateScore()

        self.delegate.gameDidChange()
    }

    func dealCards(_ amount: Int) {
        guard self.canDrawCards else {
            assertionFailure("This case should be handled by UI")
            return
        }

        if !self.matchedCardsIndices.isEmpty {
            removeMatchedCards()
        }

        let cards = drawCards(amount)
        showCards(cards)

        self.delegate.gameDidChange()
    }

    func getCardState(for indexOnBoard: Int) -> CardState? {
        guard let ID = getCardID(by: indexOnBoard) else {
            return .none
        }

        if self.matchedCardsIndices.contains(ID) {
            return .matched
        }
        else if self.unmatchedCardsIndices.contains(ID) {
            return .unmatched
        }
        else if self.chosenCardsIndices.contains(ID) {
            return .chosen
        }
        else {
            return .none
        }
    }

    static private func generateDeck() -> Array<Card> {
        var deck: Array<Card> = []
        var iterator = 0
        for color in Card.Color.allCases {
            for shade in Card.Shade.allCases {
                for shape in Card.Shape.allCases {
                    for number in Card.Number.allCases {
                        deck.append(Card(color: color, shade: shade, shape: shape, number: number, ID: iterator))
                        iterator += 1
                    }
                }
            }
        }

        return deck//.shuffled()
    }

    private func drawCards(_ amount: Int) -> Array<Card> {
        guard self.deck.count >= amount else {
            return []
        }

        var cards: [Card] = []
        for _ in 0 ..< amount {
            cards.append(self.deck.popLast()!)
        }

        return cards
    }

    private func showCards(_ cards: [Card]) {
        for card in cards {
            if let indexOnBoard = findEmptySlot() {
                self.shownCards[indexOnBoard] = card
            }
            else {
                self.shownCards.append(card)
            }
        }
    }

    private func findEmptySlot() -> Int? {
        self.shownCards.firstIndex { $0 == nil }
    }

    private func updateSelectedState(for cardID: Int) {
        if self.chosenCardsIndices.contains(cardID) {
            chosenCardsIndices.removeAll { $0 == cardID }
        }
        else {
            self.chosenCardsIndices.append(cardID)
        }
    }

    private func updateMatchingState(for cardIndex: Int) {
        guard self.chosenCardsIndices.count == 3 else {
            return
        }

        if matchCards() {
            self.matchedCardsIndices.append(contentsOf: self.chosenCardsIndices)
        }
        else {
            self.unmatchedCardsIndices.append(contentsOf: self.chosenCardsIndices)
        }

        self.chosenCardsIndices.removeAll()
    }

    private func updateScore() {
        if !self.matchedCardsIndices.isEmpty {
            self.score += 3
        }
        else if !self.unmatchedCardsIndices.isEmpty {
            self.score -= 3
        }
    }

    private func removeMatchedCards() {
        let matchedIndexesOnBoard = self.matchedCardsIndices.map { getCardIndexOnBoard(by: $0) }.compactMap { $0 }

        for indexOnBoard in matchedIndexesOnBoard {
            self.shownCards[indexOnBoard] = nil
        }

        self.matchedCardsIndices.removeAll()
    }

    private func deselectUnmatchedCardsIfNeeded() {
        guard self.unmatchedCardsIndices.count == 3 else {
            return
        }

        self.unmatchedCardsIndices.removeAll()
    }

    private func matchCards() -> Bool {
        guard self.chosenCardsIndices.count == 3 else {
            return false
        }

        var chosenCards: [Card] = []
        for ID in self.chosenCardsIndices {
            if let card = self.shownCards.compactMap({ $0 }).first(where: { $0.ID == ID }) {
                chosenCards.append(card)
            }
        }

        let cardsNumbers = chosenCards.map { $0.number }
        let cardsShapes = chosenCards.map { $0.shape }
        let cardsShades = chosenCards.map { $0.shade }
        let cardsColors = chosenCards.map { $0.color }

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

    private func getCardID(by indexOnBoard: Int) -> Int? {
        self.shownCards.compactMap { $0 }[indexOnBoard].ID
    }

    private func getCardIndexOnBoard(by ID: Int) -> Int? {
        self.shownCards.firstIndex { $0?.ID == ID }
    }

}

protocol SetGameDelegate {
    func gameDidChange()
}
