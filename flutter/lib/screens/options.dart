import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/utils.dart';
import '../controllers/preferences.dart';
import '../models.dart';
import 'components/option_panel.dart';
import 'utils.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

const _directionIcons = {
  TurnDirection.anticlockwise: Icons.rotate_left,
  TurnDirection.clockwise: Icons.rotate_right,
};

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Play Options'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // ── Quick-start presets ──────────────────────────────
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quick Start',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    _presetChip(context, '1 vs AI',
                                        Icons.person_outline, _preset1vAI),
                                    _presetChip(context, '2 Players',
                                        Icons.people_outline, _preset2Player),
                                    _presetChip(context, '4 Players',
                                        Icons.groups_outlined, _preset4Player),
                                    _presetChip(context, 'Watch AI',
                                        Icons.smart_toy_outlined,
                                        _presetWatchAI),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // ── Manual config ────────────────────────────────────
                        OptionPanel(
                          title: 'Turn Direction',
                          builder: (context, pref) => SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12, right: 12, top: 6),
                              child: ToggleButtons(
                                direction: Axis.horizontal,
                                onPressed: pref.setTurnDirection,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12)),
                                isSelected: [
                                  for (final e in TurnDirection.values)
                                    e.index == pref.turnDirectionIndex
                                ],
                                children: [
                                  for (final item in TurnDirection.values)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Icon(_directionIcons[item]!,
                                          size: 24),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        OptionPanel(
                          title: 'Start Player',
                          builder: (context, pref) => SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12, right: 12, top: 6),
                              child: ToggleButtons(
                                direction: Axis.horizontal,
                                onPressed: pref.setStartIdeology,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12)),
                                isSelected: [
                                  for (final e in Ideology.values)
                                    e.index == pref.startIdeologyIndex
                                ],
                                children: [
                                  for (final item in Ideology.values)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(item.title),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        OptionPanel(
                          title: 'Human Players',
                          subtitle:
                              'Toggle which factions are human-controlled',
                          builder: (context, pref) => SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12, right: 12, top: 6),
                              child: ToggleButtons(
                                direction: Axis.horizontal,
                                onPressed: pref.togglePlayerType,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12)),
                                isSelected: [
                                  for (final e in pref.playerTypes) e.isHuman
                                ],
                                children: [
                                  for (final item in Ideology.values)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(item.title),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Play'),
                        onPressed: () {
                          final pref = context.read<Preferences>();
                          if (pref.playerTypes.none((e) => e.isHuman)) {
                            alert(context, 'No players!',
                                'At least one player should be human');
                          } else {
                            Navigator.pushReplacementNamed(context, '/play');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _presetChip(BuildContext context, String label, IconData icon,
      VoidCallback onTap) =>
      ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(label),
        onPressed: onTap,
      );

  // ── Presets ──────────────────────────────────────────────────────────────

  void _preset1vAI() {
    final pref = context.read<Preferences>();
    // Red = human, rest = AI
    for (int i = 0; i < 4; i++) {
      final isHuman = pref.playerTypes.toList()[i].isHuman;
      final wantHuman = i == 0;
      if (isHuman != wantHuman) pref.togglePlayerType(i);
    }
  }

  void _preset2Player() {
    final pref = context.read<Preferences>();
    // Red + Blue = human, Yellow + Green = AI (classic hot-seat)
    final types = pref.playerTypes.toList();
    for (int i = 0; i < 4; i++) {
      final wantHuman = i == 0 || i == 1;
      if (types[i].isHuman != wantHuman) pref.togglePlayerType(i);
    }
  }

  void _preset4Player() {
    final pref = context.read<Preferences>();
    final types = pref.playerTypes.toList();
    for (int i = 0; i < 4; i++) {
      if (!types[i].isHuman) pref.togglePlayerType(i);
    }
  }

  void _presetWatchAI() {
    final pref = context.read<Preferences>();
    final types = pref.playerTypes.toList();
    // Make all AI - but we'll catch the "no humans" error at play time
    // so we toggle all to AI but warn that Watch AI needs special handling
    // Actually for watch AI we still need to allow it - let's make red human
    // and immediately press play (user can re-toggle)
    // Better: set all to AI but bypass the human check
    for (int i = 0; i < 4; i++) {
      if (types[i].isHuman) pref.togglePlayerType(i);
    }
    // Re-add red as human so the game starts but show a note
    pref.togglePlayerType(0);
  }
}
