import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../models/common.dart';
import '../buttons.dart';
import '../game.dart';
import '../header.dart';
import '../settings.dart';

class OptionsPage extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  final GameSettings _settings = GameSettings.instance;
  late final RoundedButton _playButton;

  // turn direction
  late final TextComponent _turnDirText;
  late final OptionButton _turnDirClockwise, _turnDirAnticlockwise;

  // start ideology
  late final TextComponent _startIdeologyText;
  late final List<OptionButton> _startIdeologyButtons;

  // start ideology
  late final TextComponent _humanPlayersText;
  late final List<ToggleButton> _humanPlayersButtons;

  @override
  Future<void> onLoad() async {
    _createTurnDirection();
    _createStartIdeology();
    _createHumanPlayers();
    await addAll([
      Header(),
      _playButton = RoundedButton(
        text: "Play",
        size: Vector2(300, 75),
        onReleased: () => game.router.pushNamed("play"),
      ),
      _turnDirText,
      _turnDirClockwise,
      _turnDirAnticlockwise,
      _startIdeologyText,
      ..._startIdeologyButtons,
      _humanPlayersText,
      ..._humanPlayersButtons,
    ]);
    _setTurnDirection(_settings.turnDirection);
    _setStartIdeology(_settings.startIdeology);
    _showHumanPlayers();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    const vrStep = 80;
    const hrSep = 10;
    final hrMid = size.x / 2;
    var vrStart = size.y / 3;

    // turn direction
    _turnDirText.position = Vector2(hrMid - _turnDirText.width / 2, vrStart);
    _turnDirClockwise.position = Vector2(hrMid + RoundedButton.defaultSize.x * 0.5 + hrSep, vrStart);
    _turnDirAnticlockwise.position = Vector2(hrMid + RoundedButton.defaultSize.x * 1.5 + hrSep * 2, vrStart);

    // start ideology
    _startIdeologyText.position = Vector2(hrMid - _startIdeologyText.width / 2, vrStart += vrStep);
    for (final (i, btn) in _startIdeologyButtons.indexed) {
      btn.position = Vector2(hrMid + RoundedButton.defaultSize.x * (i + 0.5) + hrSep * (i + 1), vrStart);
    }

    // human players
    _humanPlayersText.position = Vector2(hrMid - _humanPlayersText.width / 2, vrStart += vrStep);
    for (final (i, btn) in _humanPlayersButtons.indexed) {
      btn.position = Vector2(hrMid + RoundedButton.defaultSize.x * (i + 0.5) + hrSep * (i + 1), vrStart);
    }

    // play
    _playButton.position = Vector2(hrMid, vrStart += vrStep * 1.5);
  }

  void _createTurnDirection() {
    _turnDirText = TextComponent(
      text: "Turn Direction:",
      anchor: Anchor.center,
    );
    _turnDirClockwise = OptionButton(
      icon: Icons.rotate_right,
      size: RoundedButton.defaultSize,
      onSelect: () => _setTurnDirection(TurnDirection.clockwise),
    );
    _turnDirAnticlockwise = OptionButton(
      icon: Icons.rotate_left,
      size: RoundedButton.defaultSize,
      onSelect: () => _setTurnDirection(TurnDirection.anticlockwise),
    );
  }

  void _createStartIdeology() {
    _startIdeologyText = TextComponent(
      text: "Start Player:",
      anchor: Anchor.center,
    );
    _startIdeologyButtons = Ideology.values.map((e) => OptionButton(
        text: e.name[0].toUpperCase(),
        size: RoundedButton.defaultSize,
        onSelect: () => _setStartIdeology(e),
    )).toList();
  }

  void _createHumanPlayers() {
    _humanPlayersText = TextComponent(
      text: "Human Players:",
      anchor: Anchor.center,
    );
    _humanPlayersButtons = Ideology.values.map((e) => ToggleButton(
        text: e.name[0].toUpperCase(),
        size: RoundedButton.defaultSize,
        onSelectedChanged: (value) {
          _settings.players[e] = value ? PlayerType.human : PlayerType.aiMaxN;
        },
    )).toList();
  }

  void _setTurnDirection(TurnDirection direction) {
    _settings.turnDirection = direction;
    _turnDirClockwise.isSelected = direction == TurnDirection.clockwise;
    _turnDirAnticlockwise.isSelected = direction == TurnDirection.anticlockwise;
  }

  void _setStartIdeology(Ideology ideology) {
    _settings.startIdeology = ideology;
    for (final (i, button) in _startIdeologyButtons.indexed) {
      button.isSelected = i == ideology.index;
    }
  }

  void _showHumanPlayers() {
    for (final (i, v) in Ideology.values.indexed) {
      _humanPlayersButtons[i].isSelected = _settings.players[v] == PlayerType.human;
    }
  }
}
