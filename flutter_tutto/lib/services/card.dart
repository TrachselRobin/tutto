enum CardType {
  bonus,
  stop,
  firework,
  straight,
  plusMinus,
  doublePoints,
  cloverleaf,
}

class Card {
  final String name;
  final String description;
  final int amount;
  final String imageUrl;

  Card({
    required this.name,
    required this.description,
    this.imageUrl = '',
    this.amount = 1,
  });

  @override
  String toString() {
    return '$name: $description';
  }
}
