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

    const vrSep = 65;
    const hrSep = 15;
    final hrMid = size.x * 0.55;
    var vrStart = size.y * 0.30;

    // turn direction
    _turnDirText.position = Vector2(hrMid - hrSep, vrStart);
    _turnDirClockwise.position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 0.5, vrStart);
    _turnDirAnticlockwise.position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 1.5 + hrSep, vrStart);

    // start ideology
    _startIdeologyText.position = Vector2(hrMid - hrSep, vrStart += vrSep * 1.5);
    _startIdeologyButtons[Ideology.green.index].position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 0.5, vrStart);
    _startIdeologyButtons[Ideology.yellow.index].position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 1.5 + hrSep, vrStart);
    _startIdeologyButtons[Ideology.red.index].position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 0.5, vrStart += vrSep);
    _startIdeologyButtons[Ideology.blue.index].position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 1.5 + hrSep, vrStart);

    // human players
    _humanPlayersText.position = Vector2(hrMid - hrSep, vrStart += vrSep * 1.5);
    _humanPlayersButtons[Ideology.green.index].position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 0.5, vrStart);
    _humanPlayersButtons[Ideology.yellow.index].position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 1.5 + hrSep, vrStart);
    _humanPlayersButtons[Ideology.red.index].position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 0.5, vrStart += vrSep);
    _humanPlayersButtons[Ideology.blue.index].position =
        Vector2(hrMid + RoundedButton.defaultSize.x * 1.5 + hrSep, vrStart);

    // play
    _playButton.position = Vector2(size.x / 2, size.y - _playButton.height - hrSep);
  }

  void _createTurnDirection() {
    _turnDirText = TextComponent(
      text: "Turn Direction:",
      anchor: Anchor.centerRight,
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
      anchor: Anchor.centerRight,
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
      anchor: Anchor.centerRight,
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
