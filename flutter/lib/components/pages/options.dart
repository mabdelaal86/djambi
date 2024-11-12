import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../common/utils.dart';
import '../../models/enums.dart';
import '../buttons.dart';
import '../configs.dart' as configs;
import '../header.dart';
import '../options.dart';
import '../utils.dart';
import 'base.dart';

const _ideologyAnchor = {
  Ideology.red: Anchor.bottomLeft,
  Ideology.blue: Anchor.bottomRight,
  Ideology.yellow: Anchor.topRight,
  Ideology.green: Anchor.topLeft,
};

final _labelSize = Vector2(200, configs.smallBtnSize.y);
final _buttonsPanelSize = (configs.smallBtnSize * 2) +
    Vector2.all(configs.smallMargin);

class OptionsPage extends BasePage {
  // @override
  // bool get debugMode => true;

  late final OptionButton _turnDirClockwise, _turnDirAnticlockwise;
  late final List<OptionButton> _startIdeologyButtons;
  late final List<ToggleButton> _humanPlayersButtons;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Header(),
      PositionComponent(
        anchor: Anchor.center,
        position: size * 0.5,
        size: Vector2(
          _labelSize.x + configs.smallMargin + _buttonsPanelSize.x,
          configs.smallBtnSize.y + 2 * (configs.largeMargin + _buttonsPanelSize.y),
        ),
        children: [
          _createTurnDirection(),
          _createStartIdeology(),
          _createHumanPlayers(),
        ],
      ),
      RoundedButton(
        text: "Play",
        size: configs.largeBtnSize,
        anchor: Anchor.bottomCenter,
        position: Vector2(size.x / 2, size.y - configs.largeMargin),
        onReleased: () => game.router.pushReplacementNamed("play"),
      ),
    ]);
    _setTurnDirection(game.options.turnDirection);
    _setStartIdeology(game.options.startIdeology);
    _showHumanPlayers();
  }

  Component _createTurnDirection() =>
      PositionComponent(
        position: Vector2.zero(),
        size: Vector2(
          _labelSize.x + configs.smallMargin + _buttonsPanelSize.x,
          configs.smallBtnSize.y,
        ),
        children: [
          _createLabel("Turn Direction:"),
          PositionComponent(
            position: Vector2(_labelSize.x + configs.smallMargin, 0),
            size: Vector2(
              configs.smallBtnSize.x * 2 + configs.smallMargin,
              configs.smallBtnSize.y,
            ),
            children: [
              _turnDirClockwise = OptionButton(
                icon: Icons.rotate_right,
                fontSize: configs.iconFontSize,
                size: configs.smallBtnSize,
                position: Anchor.topLeft.ofSize(_buttonsPanelSize),
                anchor: Anchor.topLeft,
                onSelect: () => _setTurnDirection(TurnDirection.clockwise),
              ),
              _turnDirAnticlockwise = OptionButton(
                icon: Icons.rotate_left,
                fontSize: configs.iconFontSize,
                size: configs.smallBtnSize,
                position: Anchor.topRight.ofSize(_buttonsPanelSize),
                anchor: Anchor.topRight,
                onSelect: () => _setTurnDirection(TurnDirection.anticlockwise),
              ),
            ],
          ),
        ],
      );

  Component _createStartIdeology() =>
      PositionComponent(
        position: Vector2(0, configs.smallBtnSize.y + configs.largeMargin),
        size: Vector2(
          _labelSize.x + configs.smallMargin + _buttonsPanelSize.x,
          _buttonsPanelSize.y,
        ),
        children: [
          _createLabel("Start Player:"),
          PositionComponent(
            position: Vector2(_labelSize.x + configs.smallMargin, 0),
            size: _buttonsPanelSize,
            children: _startIdeologyButtons = Ideology.values.map((e) => OptionButton(
              text: e.name[0].toUpperCase(),
              size: configs.smallBtnSize,
              position: _ideologyAnchor[e]?.ofSize(_buttonsPanelSize),
              anchor: _ideologyAnchor[e],
              onSelect: () => _setStartIdeology(e),
            )).toList(),
          ),
        ],
      );

  Component _createHumanPlayers() =>
      PositionComponent(
        position: Vector2(0, configs.smallBtnSize.y + _buttonsPanelSize.y + 2 * configs.largeMargin),
        size: Vector2(
          _labelSize.x + configs.smallMargin + _buttonsPanelSize.x,
          _buttonsPanelSize.y,
        ),
        children: [
          _createLabel("Human Players:"),
          PositionComponent(
            position: Vector2(_labelSize.x + configs.smallMargin, 0),
            size: _buttonsPanelSize,
            children: _humanPlayersButtons = Ideology.values.map((e) => ToggleButton(
              text: e.name[0].toUpperCase(),
              size: configs.smallBtnSize,
              position: _ideologyAnchor[e]?.ofSize(_buttonsPanelSize),
              anchor: _ideologyAnchor[e],
              onSelectedChanged: (value) {
                game.options.players[e] = value ? PlayerType.human : PlayerType.aiMaxN;
              },
            )).toList(),
          ),
        ],
      );

  Component _createLabel(String text, {Vector2? position}) =>
      PositionComponent(
        size: _labelSize,
        position: position,
        children: [
          TextComponent(
            text: text,
            textRenderer: getRenderer(configs.defaultFontSize, configs.textColor),
            anchor: Anchor.centerRight,
            position: Anchor.centerRight.ofSize(_labelSize),
          ),
        ],
      );

  void _setTurnDirection(TurnDirection direction) {
    game.options.turnDirection = direction;
    _turnDirClockwise.isSelected = direction == TurnDirection.clockwise;
    _turnDirAnticlockwise.isSelected = direction == TurnDirection.anticlockwise;
  }

  void _setStartIdeology(Ideology ideology) {
    game.options.startIdeology = ideology;
    for (final (i, button) in _startIdeologyButtons.indexed) {
      button.isSelected = i == ideology.index;
    }
  }

  void _showHumanPlayers() {
    for (final (i, v) in Ideology.values.indexed) {
      _humanPlayersButtons[i].isSelected = game.options.players[v]!.isHuman;
    }
  }
}
