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

const _icons = {TurnDirection.anticlockwise: Icons.rotate_left, TurnDirection.clockwise: Icons.rotate_right};

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text("Play Options")),
    body: Padding(
      padding: const EdgeInsetsGeometry.all(15),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  OptionPanel(
                    title: "Turn Direction",
                    builder: (context, pref) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12, right: 12, top: 6),
                        child: ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: pref.setTurnDirection,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          isSelected: [for (final e in TurnDirection.values) e.index == pref.turnDirectionIndex],
                          children: [
                            for (final item in TurnDirection.values)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  String.fromCharCode(_icons[item]!.codePoint),
                                  style: TextStyle(fontFamily: _icons[item]!.fontFamily, fontSize: 24),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  OptionPanel(
                    title: "Start Player",
                    builder: (context, pref) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12, right: 12, top: 6),
                        child: ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: pref.setStartIdeology,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          isSelected: [for (final e in Ideology.values) e.index == pref.startIdeologyIndex],
                          children: [
                            for (final item in Ideology.values)
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(item.title)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  OptionPanel(
                    title: "Human Players",
                    builder: (context, pref) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12, right: 12, top: 6),
                        child: ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: pref.togglePlayerType,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          isSelected: [for (final e in pref.playerTypes) e.isHuman],
                          children: [
                            for (final item in Ideology.values)
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Play'),
                      onPressed: () {
                        final pref = context.read<Preferences>();
                        if (pref.playerTypes.none((e) => e.isHuman)) {
                          alert(context, "No players!", "At least on player should be human");
                        } else {
                          Navigator.pushReplacementNamed(context, "/play");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
