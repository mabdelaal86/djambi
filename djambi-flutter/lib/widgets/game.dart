import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final DjambiGame _game;

  @override
  void initState() {
    super.initState();
    _game = DjambiGame();
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 2: _game.state.undo(); break;
        case 3: _game.state.redo(); break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return GameWidget(game: _game);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Djambi"),
      ),
      body: Center(
        child: GameWidget(game: _game),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.undo),
            label: 'Undo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.redo),
            label: 'Redo',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
