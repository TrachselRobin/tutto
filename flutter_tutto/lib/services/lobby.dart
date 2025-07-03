import 'dart:math';

class Player {
  final String id;
  bool isReady;

  Player({required this.id, this.isReady = false});
}

class Lobby {
  final String code;
  final List<Player> players;

  Lobby._(this.code) : players = [];

  static Lobby create() {
    final code = _generateCode();
    return Lobby._(code);
  }

  static String _generateCode() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  bool join(String playerId) {
    if (players.length >= 6) return false;
    if (players.any((p) => p.id == playerId)) return false;
    players.add(Player(id: playerId));
    return true;
  }

  void toggleReady(String playerId) {
    final player = players.firstWhere((p) => p.id == playerId);
    player.isReady = !player.isReady;
  }

  bool get allReady =>
      players.length >= 2 &&
      players.length <= 4 &&
      players.every((p) => p.isReady);
}
