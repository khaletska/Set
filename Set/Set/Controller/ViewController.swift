//
//  ViewController.swift
//  Set
//
//  Created by Yeliena Khaletska on 11.06.2024.
//

import UIKit

final class ViewController: UIViewController {

    private var game: SetGame!
    @IBOutlet private var cardButtons: [CardButton]!
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

    @IBAction private func cardButtonTapped(_ button: CardButton) {
        if let index = self.cardButtons.firstIndex(of: button) {
            self.game.touchCard(index: index)
        }
    }

    private func startNewGame() {
        self.game = SetGame()
        self.game.delegate = self
        self.game.dealCards(12)
    }

    private func updateUI() {
        for (index, button) in self.cardButtons.enumerated() {
            if let card = self.game.getCard(for: index) {
                button.color = card.getColor()
                button.shape = card.shape
                button.number = card.number
                button.configuration?.background.strokeColor = getCardHighlightColor(for: index)
                button.configuration?.background.strokeWidth = 3
                button.isHidden = false
            }
            else {
                button.isHidden = true
            }
        }

        self.scoreLabel.text = "Score: \(self.game.score)"
        self.drawThreeMoreCardsButton.isEnabled = self.game.canDrawCards
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

    func getOpacity() -> CGFloat {
        switch self.shade {
        case .open:
            return 0.0
        case .striped:
            return 0.15
        case .solid:
            return 1.0
        }
    }

}
