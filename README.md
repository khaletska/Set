# Set

[Set](https://en.wikipedia.org/wiki/Set_(card_game)) game solo (i.e. one player) version implemented in Swift.

## Description

Set is a card game where players aim to identify sets of three cards that share specific characteristics. The game is designed to challenge pattern recognition and cognitive skills, making it a fun and educational experience for players of all ages.

## Rules

### Objective

The objective of the game is to identify as many sets of three cards as possible from a layout.

### Card Features

Each card has four features, each with three possible variations:

- *Shape*: Oval, Squiggle, or Diamond
- *Color*: Red, Green, or Purple
- *Number*: One, Two, or Three symbols
- *Shading*: Solid, Striped, or Open

### Deck

Deck consists of 81 unique cards that vary in four features across three possibilities for each kind of feature.

### Definition of a Set

A set consists of three cards satisfying all of these conditions:

- They all have the same number or have three different numbers.
- They all have the same shape or have three different shapes.
- They all have the same shading or have three different shadings.
- They all have the same color or have three different colors.

### Gameplay

1. Game starts with 12 random cards in 3x4 layout.
2. Player tries to find sets of three cards.
3. If the player identifies a set, they select the three cards.
4. The identified cards are checked to confirm if they form a valid set.
    - If correct, the cards will be highlighted in green and disappear from the board with the next move. The player is rewarded 3 points.
    - If incorrect, the cards will be highlighted in red and remain on the board. The player loses 3 points.
5. The player can deal three more cards at any time until there are up to twenty-four cards on the table.
6. The game continues until the deck is empty.

### Winning
The game is scored based on the number of sets found, with points awarded or deducted for correct or incorrect sets, respectively. The player aims to achieve the highest possible score by the end of the game.
