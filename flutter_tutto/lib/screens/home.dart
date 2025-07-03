import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lobby.dart';
import '../services/lobby.dart';

class Home extends StatelessWidget {
  Player player = Player(id: "player");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCC0000),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tutto!',
                style: GoogleFonts.interTight(
                  textStyle: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              TextField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  labelText: 'Enter Player Name',
                  border: OutlineInputBorder()
                ),
                style: GoogleFonts.interTight(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                // on fill in the player name
                onSubmitted: (value) {
                  // Hier sollte der PlayerId dynamisch generiert werden
                  if (value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a player name')),
                    );
                    return;
                  }
                  player = Player(id: value);
                  print('Player ID: ${player.id}');
                },
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final lobby = Lobby.create();
                    lobby.join(player.id); // Hardcoded oder generieren

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameLobby(
                          lobby: lobby,
                          // Hier sollte der PlayerId dynamisch übergeben werden
                          playerId: player.id,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFCC0000),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Create Lobby'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Join Lobby'),
                          content: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter Lobby Code',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Hier sollte die Logik zum Beitreten der Lobby implementiert werden
                                // Zum Beispiel: lobby.join(player.id);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Joined Lobby')),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameLobby(
                                      lobby: Lobby.create(), // Hier sollte die Lobby-Instanz übergeben werden
                                      playerId: player.id, // Hier sollte der PlayerId dynamisch übergeben werden
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Join'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Join Lobby'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
