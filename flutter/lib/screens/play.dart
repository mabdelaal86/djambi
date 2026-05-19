import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/game.dart';
import '../controllers/preferences.dart';
import 'utils.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late final DjambiGame _game;

  @override
  Widget build(BuildContext context) => PopScope<bool>(
    canPop: false,
    child: Scaffold(
      appBar: AppBar(
        title: const Text("Djambi"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: () => _game.undo(), icon: const Icon(Icons.undo)),
          IconButton(onPressed: () => _game.redo(), icon: const Icon(Icons.redo)),
        ],
      ),
      body: GameWidget(
        game: _game = DjambiGame(
          preferences: context.read<Preferences>(),
          surface: Theme.of(context).colorScheme.surface,
        ),
      ),
    ),
    onPopInvokedWithResult: (didPop, result) async {
      if (didPop) {
        return;
      }
      final shouldPop =
          _game.finished ||
          _game.noHumans ||
          (await confirm(context, "Are you sure?", "The match state will not be saved") ?? false);
      if (context.mounted && shouldPop) {
        Navigator.pop(context, result);
      }
    },
  );
}
