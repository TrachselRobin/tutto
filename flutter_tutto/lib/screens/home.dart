import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen_two.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCC0000),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Tutto!',
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // button for Create Lobby
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScreenTwo()),
                    );
                  },
                  child: Text(
                    'Create Lobby',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                // button for Join Lobby. When you click on it, you can enter the lobby code. so basically a text field
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Join Lobby'),
                          content: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter Lobby Code',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Join'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Join Lobby',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
