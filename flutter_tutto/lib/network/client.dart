// client.dart
import 'dart:io';

class Client {
  Socket? _socket;
  String playerName = "Client";

  Future<void> connect(String ip, {int port = 4567}) async {
    _socket = await Socket.connect(ip, port);
    _socket!.listen((data) {
      final message = String.fromCharCodes(data).trim();
      print("Empfangen vom Host: \$message");
      // Weiterleiten an GameState etc. später
    });
  }

  void sendPlayerName(String name) {
    playerName = name;
    send("JOIN:\$name");
  }

  void send(String message) {
    _socket?.write("$message\n");
  }

  void dispose() {
    _socket?.close();
  }
}
