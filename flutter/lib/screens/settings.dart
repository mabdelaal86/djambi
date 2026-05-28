import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/utils.dart';
import '../controllers/preferences.dart';
import '../models/ai/tree.dart';
import '../views.dart';
import 'components/option_panel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final pref = context.watch<Preferences>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                OptionPanel(
                  title: 'Notation Borders',
                  subtitle: 'Show column/row labels around the board',
                  builder: (context, pref) => _toggleRow(
                    onPressed: pref.setNotationVisibility,
                    isSelected: [
                      for (final e in NotationVisibility.values)
                        e.index == pref.notationVisibilityIndex
                    ],
                    labels: NotationVisibility.values
                        .map<String>((e) => e.title)
                        .toList(),
                  ),
                ),
                OptionPanel(
                  title: 'Game Speed',
                  subtitle: 'Delay before AI makes its move',
                  builder: (context, pref) => _toggleRow(
                    onPressed: pref.setGameSpeed,
                    isSelected: [
                      for (final e in GameSpeed.values)
                        e.index == pref.gameSpeedIndex
                    ],
                    labels: GameSpeed.values
                        .map<String>((e) => e.title)
                        .toList(),
                  ),
                ),
                OptionPanel(
                  title: 'AI Difficulty',
                  subtitle: 'How many moves ahead the AI thinks',
                  builder: (context, pref) => _toggleRow(
                    onPressed: pref.setAiDifficulty,
                    isSelected: [
                      for (final e in AiDifficulty.values)
                        e.index == pref.aiDifficultyIndex
                    ],
                    icons: [
                      Icons.sentiment_satisfied_alt,
                      Icons.psychology,
                      Icons.whatshot,
                    ],
                    labels: AiDifficulty.values
                        .map<String>((e) => e.title)
                        .toList(),
                  ),
                ),
                // Sound toggle
                Card(
                  child: SwitchListTile(
                    title: const Text('Sound Effects'),
                    subtitle: const Text('Play sounds for moves, kills and win'),
                    secondary: Icon(
                      pref.soundEnabled
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                    ),
                    value: pref.soundEnabled,
                    onChanged: pref.setSoundEnabled,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _toggleRow({
    required void Function(int) onPressed,
    required List<bool> isSelected,
    required List<String> labels,
    List<IconData>? icons,
  }) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 12, right: 12, top: 6),
          child: ToggleButtons(
            direction: Axis.horizontal,
            onPressed: onPressed,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            isSelected: isSelected,
            children: [
              for (int i = 0; i < labels.length; i++)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14),
                  child: icons != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icons[i], size: 16),
                            const SizedBox(width: 6),
                            Text(labels[i]),
                          ],
                        )
                      : Text(labels[i]),
                ),
            ],
          ),
        ),
      );
}
