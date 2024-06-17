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
        (self.shownCards.compactMap { $0 }.count < 24 ||
         self.matchedCardsIndices.count > 2) &&
        self.deck.count > 2
    }

    private var deck = Array<Card>()
    private var shownCards: Array<Card?>
    private var chosenCardsIndices: Array<Int>
    private var matchedCardsIndices: Array<Int>
    private var unmatchedCardsIndices: Array<Int>
    private(set) var score: Int

    init() {
        self.shownCards = .init(repeating: nil, count: 24)
        self.chosenCardsIndices = []
        self.matchedCardsIndices = []
        self.unmatchedCardsIndices = []
        self.score = 0
        generateDeck()
    }

    func dealCards(_ amount: Int) {
        if matchedCardsIndices.count > 2 {
            replaceMatchedCardsIfNeeded()
        }
        else {
            let cards = drawCards(amount)
            showCards(cards)
        }
    }

    func touchCard(index: Int) {
        guard !self.matchedCardsIndices.contains(index) else {
            return
        }

        replaceMatchedCardsIfNeeded()
        deselectUnmatchedCardsIfNeeded()
        updateSelectedState(for: index)
        updateMatchingState(for: index)
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
        guard self.chosenCardsIndices.count > 2 else {
            return
        }

        if matchCards() {
            self.matchedCardsIndices.append(contentsOf: self.chosenCardsIndices)
            self.score += 3
        }
        else {
            self.unmatchedCardsIndices.append(contentsOf: self.chosenCardsIndices)
            self.score -= 3
        }

        self.chosenCardsIndices.removeAll()
    }

    private func replaceMatchedCardsIfNeeded() {
        guard self.matchedCardsIndices.count > 2 else {
            return
        }

        for index in self.matchedCardsIndices {
            self.shownCards[index] = nil
        }

        self.matchedCardsIndices.removeAll()
        dealCards(3)
    }

    private func deselectUnmatchedCardsIfNeeded() {
        guard self.unmatchedCardsIndices.count > 2 else {
            return
        }

        self.unmatchedCardsIndices.removeAll()
    }

    private func matchCards() -> Bool {
        guard self.chosenCardsIndices.count > 2 else {
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
