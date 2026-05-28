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
  // Nullable so we can guard against double-init caused by hot-reload or
  // Navigator pushing the rules page and returning (which triggers a rebuild).
  DjambiGame? _game;

  bool get _gameReady => _game != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only create the game once — didChangeDependencies can be called again
    // (e.g. when returning from the Rules page) but we must NOT recreate it.
    if (_game != null) return;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final continueGame = args?['continue'] as bool? ?? false;

    _game = DjambiGame(
      preferences: context.read<Preferences>(),
      surface: Theme.of(context).colorScheme.surface,
      continueGame: continueGame,
    );
  }

  @override
  Widget build(BuildContext context) => PopScope<bool>(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Djambi'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.undo),
                tooltip: 'Undo',
                onPressed: _gameReady ? () => _game!.undo() : null,
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                tooltip: 'Redo',
                onPressed: _gameReady ? () => _game!.redo() : null,
              ),
              IconButton(
                icon: const Icon(Icons.menu_book_outlined),
                tooltip: 'Rules',
                // Navigate without rebuilding the game — pushNamed is safe
                // because we guard re-init with the null check above.
                onPressed: () => Navigator.pushNamed(context, '/rules'),
              ),
            ],
          ),
          body: SafeArea(
            child: _gameReady
                ? GameWidget(game: _game!)
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final game = _game;
          if (game == null) {
            Navigator.pop(context, result);
            return;
          }
          final shouldPop = game.finished ||
              game.noHumans ||
              (await confirm(
                    context,
                    'Are you sure?',
                    'The match will be saved and you can continue later',
                  ) ??
                  false);
          if (context.mounted && shouldPop) {
            Navigator.pop(context, result);
          }
        },
      );
}
