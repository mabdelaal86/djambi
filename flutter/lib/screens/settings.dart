import 'package:flutter/material.dart';

import '../common/utils.dart';
import '../controllers/preferences.dart';
import '../views.dart';
import 'components/option_panel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text("Settings")),
    body: Padding(
      padding: const .all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            OptionPanel(
              title: "Notation Borders",
              builder: (context, pref) => SingleChildScrollView(
                scrollDirection: .horizontal,
                child: Padding(
                  padding: const .only(bottom: 12, right: 12, top: 6),
                  child: ToggleButtons(
                    direction: .horizontal,
                    onPressed: pref.setNotationVisibility,
                    borderRadius: const .all(Radius.circular(12)),
                    isSelected: [for (final e in NotationVisibility.values) e.index == pref.notationVisibilityIndex],
                    children: [
                      for (final item in NotationVisibility.values)
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(item.title)),
                    ],
                  ),
                ),
              ),
            ),
            OptionPanel(
              title: "Game Speed",
              builder: (context, pref) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12, right: 12, top: 6),
                  child: ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: pref.setGameSpeed,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    isSelected: [for (final e in GameSpeed.values) e.index == pref.gameSpeedIndex],
                    children: [
                      for (final item in GameSpeed.values)
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(item.title)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
