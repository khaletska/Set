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

                button.setAttributedTitle(card.buildString(), for: .normal)
            }
            else {
                button.isHidden = true
            }
        }
    }

}

private extension Card {

    func buildString() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: getColor().withAlphaComponent(getOpacity()),
            .strokeColor: getColor(),
            .strokeWidth: -3.0
        ]

        let string = String(repeating: getShape(), count: getNumber())
        return NSAttributedString(string: string, attributes: attributes)
    }

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

    func getShape() -> String {
        switch self.shape {
        case .diamond:
            return "▲"
        case .squiggle:
            return "■"
        case .oval:
            return "●"
        }
    }

    func getNumber() -> Int {
        switch self.number {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
    }

}
