import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart' show SystemMouseCursors;

import '../dropdownbutton.dart';
import '../button.dart';
import '../header.dart';

class SettingsPage extends PositionComponent {
  late final DropdownButton _rulesDropdown;
  late final DropdownButton _playersDropdown;
  late final DropdownButton _difficultyDropdown;
  late final Button _simple;

  final _btnSize = Vector2(300, 75);
  String _selectedRule = 'Simples';
  int _selectedPlayers = 2;
  String _selectedDifficulty = 'Facile';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Header(),
      _rulesDropdown = DropdownButton(
        label: "Rules",
        items: ['Simple', 'Advanced'],
        onItemSelected: (value) {
          _selectedRule = value;
          // Mettre à jour les règles du jeu
        },
        size: Vector2(300, 50),
      ),
      // _simple = Button(
      //   text: "Advanced",
      //   size: Vector2(300, 75),
      //   action: () {},
      // ),
      _playersDropdown = DropdownButton(
        label: "Number of players",
        items: ["3", "4", "6"],
        onItemSelected: (value) {
          _selectedPlayers = int.parse(value);
          // Mettre à jour le nombre de joueurs
        },
        size: Vector2(300, 50),
      ),
      _difficultyDropdown = DropdownButton(
        label: "Difficulty",
        items: ['Easy', 'Medium', 'Hard'],
        onItemSelected: (value) {
          _selectedDifficulty = value;
          // Mettre à jour la difficulté de l'IA
        },
        size: Vector2(300, 50),
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    _rulesDropdown.position = Vector2(size.x / 2, size.y / 3);
    _playersDropdown.position = _rulesDropdown.position + Vector2(0, 130);
    _difficultyDropdown.position = _playersDropdown.position + Vector2(0, 130);
  }
}
