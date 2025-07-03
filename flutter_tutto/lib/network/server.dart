// server.dart
import 'dart:io';

class Server {
  ServerSocket? _server;
  final List<Socket> _clients = [];
  String playerName = "Host";

  Future<void> start({int port = 4567}) async {
    _server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    _server!.listen(_handleClient);
    print("Server gestartet auf Port \$port");
  }

  void setPlayerName(String name) {
    playerName = name;
  }

  void _handleClient(Socket client) {
    _clients.add(client);
    print("Client verbunden: \${client.remoteAddress.address}");

    client.listen(
      (data) {
        final message = String.fromCharCodes(data).trim();
        print("Empfangen von Client: \$message");
        _broadcast(message, exclude: client);
      },
      onDone: () {
        _clients.remove(client);
        print("Client getrennt: \${client.remoteAddress.address}");
      },
    );
  }

  void _broadcast(String message, {Socket? exclude}) {
    for (var client in _clients) {
      if (client != exclude) {
        client.write("$message\n");
      }
    }
  }

  void broadcast(String message) => _broadcast(message);

  void dispose() {
    for (var client in _clients) {
      client.close();
    }
    _server?.close();
  }
}
