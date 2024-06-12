//
//  ViewController.swift
//  Set
//
//  Created by Yeliena Khaletska on 11.06.2024.
//

import UIKit

final class ViewController: UIViewController {

    private var game: SetGame!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var drawThreeMoreCardsButton: UIButton!
    @IBOutlet private weak var newGameButton: UIButton!

    override internal func viewDidLoad() {
        super.viewDidLoad()

        startNewGame()
    }

    @IBAction private func drawThreeMoreCardsButtonTapped() {
        self.game.drawCards(3)
        updateUI()
    }

    @IBAction private func newGameButtonTapped() {
        startNewGame()
    }

    @IBAction private func cardButtonTapped(_ button: UIButton) {
        if let index = self.cardButtons.firstIndex(of: button) {
            self.game.touchCard(index: index)
            updateUI()
        }
    }

    private func startNewGame() {
        self.game = SetGame()
        self.game.drawCards(12)
        updateUI()
    }

    private func updateUI() {
        self.drawThreeMoreCardsButton.isEnabled = self.game.canDrawCards

        for (index, button) in self.cardButtons.enumerated() {
            if let card = self.game.getCard(for: index) {
                button.configuration?.background.strokeColor = self.game.isCardChosen(at: index) ? .orange : .clear
                button.isHidden = false
                button.setTitle(card.content, for: .normal)
            }
            else {
                button.isHidden = true
            }
        }
    }

}

