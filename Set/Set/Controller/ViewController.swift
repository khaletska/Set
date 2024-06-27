//
//  ViewController.swift
//  Set
//
//  Created by Yeliena Khaletska on 11.06.2024.
//

import UIKit

final class ViewController: UIViewController {

    private var game: SetGame!
    @IBOutlet private weak var gridView: GridView!
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

    private func cardButtonTapped(_ index: Int) {
        if (self.game.shownCards[index] != nil) {
            self.game.touchCard(index: index)
        }
    }

    private func startNewGame() {
        self.game = SetGame()
        self.game.delegate = self
        self.game.dealCards(12)

        self.gridView.cardButtonTappedHandler = { [weak self] cardIndex in
            self?.cardButtonTapped(cardIndex)
        }

        self.gridView.getCardHighlightColorForCard = { [weak self] cardIndex in
            self?.getCardHighlightColor(for: cardIndex) ?? .clear
        }
    }

    private func updateUI() {
        self.gridView.add(self.game.shownCards)


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
