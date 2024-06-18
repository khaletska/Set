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
        !self.deck.isEmpty && (findEmptySlot() != nil || self.matchedCardsIndices.count == 3)
    }

    private var deck: Array<Card> = SetGame.generateDeck()
    private var shownCards: Array<Card?> = .init(repeating: nil, count: 24)
    private var chosenCardsIndices: Array<Int> = []
    private var matchedCardsIndices: Array<Int> = []
    private var unmatchedCardsIndices: Array<Int> = []
    private(set) var score: Int = 0

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
    }

    func touchCard(index: Int) {
        guard !self.matchedCardsIndices.contains(index) else {
            return
        }

        if !self.matchedCardsIndices.isEmpty {
            removeMatchedCards()

            if !self.deck.isEmpty {
                dealCards(3)
            }
        }

        deselectUnmatchedCardsIfNeeded()
        updateSelectedState(for: index)
        updateMatchingState(for: index)
        updateScore()
    }

    func getCard(for index: Int) -> Card? {
        guard index < shownCards.count else {
            return nil
        }

        return self.shownCards[index]
    }

    func getCardState(for index: Int) -> CardState? {
        if self.matchedCardsIndices.contains(index) {
            return .matched
        }
        else if self.unmatchedCardsIndices.contains(index) {
            return .unmatched
        }
        else if self.chosenCardsIndices.contains(index) {
            return .chosen
        }
        else {
            return .none
        }
    }

    static private func generateDeck() -> Array<Card> {
        var deck: Array<Card> = []
        for color in Card.Color.allCases {
            for shade in Card.Shade.allCases {
                for shape in Card.Shape.allCases {
                    for number in Card.Number.allCases {
                        deck.append(Card(color: color, shade: shade, shape: shape, number: number))
                    }
                }
            }
        }

        return deck.shuffled()
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
            if let index = findEmptySlot() {
                self.shownCards[index] = card
            }
        }
    }

    private func findEmptySlot() -> Int? {
        self.shownCards.firstIndex { $0 == nil }
    }

    private func updateSelectedState(for cardIndex: Int) {
        if self.chosenCardsIndices.contains(cardIndex) {
            chosenCardsIndices.removeAll { $0 == cardIndex }
        }
        else {
            self.chosenCardsIndices.append(cardIndex)
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
        for index in self.matchedCardsIndices {
            self.shownCards[index] = nil
        }

        self.matchedCardsIndices.removeAll()
    }

    private func replaceMatchedCardsIfNeeded() {
        guard self.matchedCardsIndices.count == 3 else {
            return
        }

        for index in self.matchedCardsIndices {
            self.shownCards[index] = nil
        }

        self.matchedCardsIndices.removeAll()
        dealCards(3)
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

        let cards = self.chosenCardsIndices.map { self.shownCards[$0] }

        let cardsNumbers = cards.map { $0!.number }
        let cardsShapes = cards.map { $0!.shape }
        let cardsShades = cards.map { $0!.shade }
        let cardsColors = cards.map { $0!.color }

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
