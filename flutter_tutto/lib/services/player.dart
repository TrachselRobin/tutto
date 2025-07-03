class Player {
  Player({
    required this.name,
  });

  final String name;

  String ipAddress = '';
  int score = 0;

  @override
  String toString() {
    return 'Player{name: $name, ipAddress: $ipAddress, score: $score}';
  }
}