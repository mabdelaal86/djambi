import 'package:flutter/material.dart';

import '../controllers/game.dart';
import 'utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasSave = false;

  @override
  void initState() {
    super.initState();
    DjambiGame.hasSavedGame().then((v) {
      if (mounted) setState(() => _hasSave = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final btnWidth = (mq.size.width * 0.75).clamp(200.0, 360.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text('Djambi'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: btnWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo
                        Column(
                          children: [
                            Icon(Icons.grid_4x4_rounded,
                                size: 64,
                                color: theme.colorScheme.primary),
                            const SizedBox(height: 8),
                            Text(
                              'DJAMBI',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 6,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              'The Game of Political Intrigue',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Continue (only shown when saved game exists)
                        if (_hasSave) ...[
                          FilledButton.icon(
                            icon: const Icon(Icons.play_circle_outline_rounded),
                            label: const Text('Continue'),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/play',
                                    arguments: {'continue': true}).then((_) {
                                  DjambiGame.hasSavedGame().then((v) {
                                    if (mounted) setState(() => _hasSave = v);
                                  });
                                }),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('New Game'),
                            onPressed: _newGame,
                          ),
                        ] else
                          FilledButton.icon(
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Play'),
                            onPressed: _newGame,
                          ),

                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.menu_book_rounded),
                          label: const Text('Rules & Pieces'),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/rules'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.settings_outlined),
                          label: const Text('Settings'),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/settings'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.info_outline_rounded),
                          label: const Text('About'),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/about'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => openUrl(
                        'https://datonomi.github.io/djambi/privacy-policy'),
                    child: const Text('Privacy Policy'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _newGame() {
    // Delete save so a new game starts fresh
    DjambiGame.deleteSavedGame().then((_) {
      if (mounted) Navigator.pushNamed(context, '/options');
    });
  }
}
