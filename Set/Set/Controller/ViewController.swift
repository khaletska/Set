//
//  ViewController.swift
//  Set
//
//  Created by Yeliena Khaletska on 11.06.2024.
//

import UIKit

final class ViewController: UIViewController {

    private var game: SetGame!
    private var gridCalculator = Grid(layout: .aspectRatio(5 / 8))
    @IBOutlet private weak var gridView: UIView!
    @IBOutlet private weak var drawThreeMoreCardsButton: UIButton!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!

    override internal func viewDidLoad() {
        super.viewDidLoad()

        startNewGame()
    }

    @IBAction private func drawThreeMoreCardsButtonTapped() {
        self.game.dealCards(3)
    }

    @IBAction private func newGameButtonTapped() {
        startNewGame()
    }

    @objc private func cardButtonTapped(_ sender: CardButton) {
        self.game.touchCard(indexOnBoard: sender.indexOnBoard)
    }

    private func startNewGame() {
        self.game = SetGame()
        self.game.delegate = self
        self.game.dealCards(12)
    }

    private func updateUI() {
        updateGrid(with: self.game.shownCards.compactMap { $0 })

        self.scoreLabel.text = "Score: \(self.game.score)"
        self.drawThreeMoreCardsButton.isEnabled = self.game.canDrawCards
    }

    private func updateGrid(with cards: [Card]) {
        self.gridView.subviews.forEach { $0.removeFromSuperview() }
        self.gridCalculator.cellCount = cards.count
        self.gridCalculator.frame = self.gridView.bounds

        for (index, card) in cards.enumerated() {
            guard let frame = self.gridCalculator[index] else {
                continue
            }

            let cardButtonView = CardButton(card: card,
                                            index: index,
                                            highlight: getCardHighlightColor(for: index),
                                            frame: frame)
            self.gridView.addSubview(cardButtonView)

            cardButtonView.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
        }
    }

    private func getCardHighlightColor(for index: Int) -> UIColor {
        switch self.game.getCardState(for: index) {
        case .chosen:
            return .systemOrange
        case .matched:
            return .systemGreen
        case .unmatched:
            return .systemRed
        case .none:
            return .clear
        }
    }
}

extension ViewController: SetGameDelegate {

    func gameDidChange() {
        updateUI()
    }

}
