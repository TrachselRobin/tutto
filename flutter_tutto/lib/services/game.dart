// ignore_for_file: avoid_print

import 'player.dart';
import 'card.dart';
import 'dart:math';

class Game {
  Game({required this.players});

  final List<Player> players;

  Player? currentPlayer;
  List<Player>? winners;
  List<Card>? cards;
  Card? currentCard;
  List<int>? dices;
  int? amountOfPlayers;

  final _random = Random();

  void start() {
    setCurrentPlayer(0);
    setAmountOfPlayers(players.length);
    cards = initializeCards();

    startGameLoop();
  }

  void startGameLoop() {
    while (winners == null || winners!.isEmpty) {
      for (var player in players) {
        // Bonuskarte aufdecken
        currentCard = drawCard(player);
        int points = 0;

        if (currentCard?.name == 'Stop') {
          points = playStop(player);
        } else if (currentCard?.name == 'Feuerwerk') {
          points = playFirework(player);
        } else if (currentCard?.name == 'Strasse') {
          points = playStrasse(player);
        } else if (currentCard?.name == 'Plus / Minus') {
          points = playPlusMinus(player);
        } else if (currentCard?.name == 'x2') {
          points = playDouble(player);
        } else if (currentCard?.name == 'Kleeblatt') {
          points = playCloverleaf(player);
        } else {
          points = playBonusCard(player);
        }

        currentPlayer?.score += points;

        checkIfPlayerWins(player);
      }
    }

    showWinners();
  }

  int playStop(Player player) {
    /*
      Der Spieler muss aussetzen, der nächste ist an der Reihe.
      Es gibt keine Punkte.
    */
    print('${player.name} must skip their turn due to Stop card.');
    return 0; // No points for Stop card
  }

  int playBonusCard(Player player) {
    /*
      Der Spieler Würfelt mit 6 Würfeln.
      Dann werden die Punkte gezählt. 
      Hat man keine PUnkte erzielt, ist der nächste Spieler an der Reihe.
      Falls man PUnkte hat: Die würfel, die keine Punkte bringen, können erneut geworfen werden.
      Diese, und NUR diese würfel, die in diesem Wurf gewürfelt wwurden, werden zu den bereits geworfenen Punkte hinzugezählt.
      Man kann also nicht mit einem vorher geworfenen 1 dieses mit 2 neu geworfenen 1en addieren und so 1000 Punkte erzielen.
      Hat man erneut gewürfelt und keine Punkte erzielt, ist der nächste Spieler an der Reihe und man verliert die in diesem Wurf erzielten Punkte.
    */
    rollDices(player, numberOfDices: 6);
    int points, unusedDices;
    Map<String, int> result = countPoints(dices!);
    
    points = result['points'] ?? 0;
    unusedDices = result['unusedDices'] ?? 0;

    if (points == 0) {
      print('${player.name} scored no points this turn.');
      return 0; // No points scored, next player
    }
    print('${player.name} scored $points points with the rolled dices.');
    int totalPoints = points;

  }

  /// Returns a Map with 'points' and 'unusedDices' keys.
  Map<String, int> countPoints(List<int> dices) {
    /*
      3x 1 = 1000 Punkte
      3x 2 = 200 Punkte
      3x 3 = 300 Punkte 
      3x 4 = 400 Punkte
      3x 5 = 500 Punkte
      3x 6 = 600 Punkte
      1x 1 = 100 Punkte
      1x 5 = 50 Punkte
    */
    int points = 0;
    int usedDices = 0;
    Map<int, int> counts = {};
    for (var dice in dices) {
      counts[dice] = (counts[dice] ?? 0) + 1;
    }
    for (var entry in counts.entries) {
      final value = entry.key;
      final count = entry.value;

      if (value == 1) {
        if (count == 6) {
          points += 2000;
          usedDices += 6;
        } else if (count >= 3) {
          points += 1000;
          usedDices += 3;
          points += (count - 3) * 100;
        } else {
          points += 100 * count;
          usedDices += count;
        }
      } else if (value == 5) {
        if (count >= 3) {
          points += 500;
          usedDices += 3;
          points += (count - 3) * 50;
        } else {
          points += 50 * count;
          usedDices += count;
        }
      } else if (count >= 3) {
        points += value * 100;
        usedDices += 3;
      }
    }
    int unusedDices = dices.length - usedDices;
    return {'points': points, 'unusedDices': unusedDices};
  }

  void rollDices(Player player, {int numberOfDices = 6}) {
    // Simulate rolling two dice
    if (numberOfDices <= 0 || numberOfDices > 6) {
      throw RangeError('Number of dices must be between 1 and 6.');
    }

    dices = List.generate(numberOfDices, (_) => _random.nextInt(6) + 1);

    print('${player.name} rolled: ${dices!.join(', ')}');

    // Placeholder for handling the rolled values
    // In a real game, you would have logic to update the player's score or state
  }

  Card drawCard(Player player) {
    // get a random int from 0 to cards.length - 1
    if (cards == null || cards!.isEmpty) {
      print('No cards left to draw.');
      throw Exception('No cards left to draw.');
    }

    final randomIndex = _random.nextInt(cards!.length);

    if (randomIndex < 0 || randomIndex >= cards!.length) {
      print('Random index out of range: $randomIndex');
      throw RangeError('Random index out of range: $randomIndex');
    }

    final drawnCard = cards![randomIndex];
    print('${player.name} drew a card: ${drawnCard.name}');

    return drawnCard;
  }

  void checkIfPlayerWins(Player player) {
    // Placeholder logic for determining if a player has won
    // In a real game, you would have specific win conditions
    if (player.score >= 10000) {
      // Assuming score is a property of Player
      winners ??= [];
      winners!.add(player);
      print('${player.name} has won the game!');
    }
  }

  void setCurrentPlayer(index) {
    if (index < 0 || index >= players.length) {
      throw RangeError('Index out of range: $index');
    }
    currentPlayer = players[index];
  }

  void setAmountOfPlayers(int amount) {
    if (amount < 0 || amount > players.length) {
      throw RangeError('Invalid number of players: $amount');
    }
    amountOfPlayers = amount;
  }

  void showCard(Card card) {
    // Placeholder for showing the card to the player
    // In a real game, this could be a UI update or a console print
    print('Showing card: ${card.name} - ${card.imageUrl}');
  }

  List<Card> initializeCards() {
    /* 
      25 Bonuskarten (je 5x 200, 300, 400, 500, 600)
      1 Kleeblattkarte
      5 Feuerwerk
      10 Stop
      5 Strasse
      5 Plus / Minus
      5 x2
    */
    cards = [
      Card(
        name: 'Bonus 200',
        description:
            "Würfelt der Spieler ein 'Tutto', erhält er 200 Bonuspunkte.",
        amount: 5,
      ),
      Card(
        name: 'Bonus 300',
        description:
            "Würfelt der Spieler ein 'Tutto', erhält er 300 Bonuspunkte.",
        amount: 5,
      ),
      Card(
        name: 'Bonus 400',
        description:
            "Würfelt der Spieler ein 'Tutto', erhält er 400 Bonuspunkte.",
        amount: 5,
      ),
      Card(
        name: 'Bonus 500',
        description:
            "Würfelt der Spieler ein 'Tutto', erhält er 500 Bonuspunkte.",
        amount: 5,
      ),
      Card(
        name: 'Bonus 600',
        description:
            "Würfelt der Spieler ein 'Tutto', erhält er 600 Bonuspunkte.",
        amount: 5,
      ),
      Card(
        name: 'Stop',
        description:
            "Pech gehabt! Der Spieler muss aussetzen, der nächste ist an der Reihe.",
        amount: 10,
      ),
      Card(
        name: 'Feuerwerk',
        description:
            "So lange würfeln, bis eine Niete geworfen wird. Alle Punkte zählen.",
        amount: 5,
      ),
      Card(
        name: 'Strasse',
        description:
            "Der Spieler muss eine Strasse (1-6) würfeln, sonst keine Punkte.",
        amount: 5,
      ),
      Card(
        name: 'Plus / Minus',
        description:
            "Bei 'Tutto': +1000 für Spieler, -1000 für führenden Gegner.",
        amount: 5,
      ),
      Card(
        name: 'x2',
        description: "Verdoppelt die Punkte des aktuellen Spielers.",
        amount: 5,
      ),
      Card(
        name: 'Kleeblatt',
        description:
            "Der Spieler darf eine Bonuskarte ziehen und sofort verwenden.",
        amount: 1,
      ),
    ];

    // create new cards list with the correct amount of each card
    List<Card> newCards = [];

    for (var card in cards!) {
      for (var i = 0; i < card.amount; i++) {
        newCards.add(card);
      }
    }

    cards = newCards;

    return cards!;
  }

  @override
  String toString() {
    return 'Game{players: $players}';
  }
}
