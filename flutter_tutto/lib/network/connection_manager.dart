// connection_manager.dart
import 'client.dart';
import 'server.dart';

enum ConnectionMode { host, client }

class ConnectionManager {
  static final ConnectionManager _instance = ConnectionManager._internal();
  factory ConnectionManager() => _instance;
  ConnectionManager._internal();

  late final ConnectionMode mode;
  Server? server;
  Client? client;

  Future<void> startAsHost(String name) async {
    mode = ConnectionMode.host;
    server = Server();
    await server!.start();
    server!.setPlayerName(name);
  }

  Future<void> connectToHost(String ip, String name) async {
    mode = ConnectionMode.client;
    client = Client();
    await client!.connect(ip);
    client!.sendPlayerName(name);
  }

  void sendDiceResult(int result) {
    if (mode == ConnectionMode.host) {
      server?.broadcast("DICE:$result");
    } else {
      client?.send("DICE:$result");
    }
  }

  void dispose() {
    server?.dispose();
    client?.dispose();
  }
}
