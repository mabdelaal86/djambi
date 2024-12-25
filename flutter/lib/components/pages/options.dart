import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../models/enums.dart';
import '../buttons/option.dart';
import '../buttons/rounded.dart';
import '../buttons/toggle.dart';
import '../configs.dart' as configs;
import '../header.dart';
import '../layout.dart';
import '../options.dart';
import '../utils.dart';
import 'base.dart';

const _ideologyAnchor = {
  Ideology.red: Anchor.bottomLeft,
  Ideology.blue: Anchor.bottomRight,
  Ideology.yellow: Anchor.topRight,
  Ideology.green: Anchor.topLeft,
};

final _labelSize = Vector2(250, configs.smallBtnSize.y);
final _buttonsPanelSize = (configs.smallBtnSize * 2) +
    Vector2.all(configs.smallMargin);

class OptionsPage extends BasePage {
  // @override
  // bool get debugMode => true;

  late final MultiAlignComponent _turnDirPanel;
  late final MultiAlignComponent _startIdeologyPanel;
  late final MultiAlignComponent _humanPlayersPanel;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Header(),
      MultiAlignComponent(
        size: size,
        padding: const EdgeInsets.all(configs.largeMargin),
        alignedChildren: {
          Anchor.center: PositionComponent(
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
          Anchor.bottomCenter: RoundedButton(
            text: "Play",
            size: configs.largeBtnSize,
            onReleased: () => game.router.pushReplacementNamed("play"),
          ),
        },
      ),
    ]);
    _setTurnDirection(game.options.turnDirection);
    _setStartIdeology(game.options.startIdeology);
    _showHumanPlayers();
  }

  Component _createTurnDirection() =>
      MultiAlignComponent(
        position: Vector2.zero(),
        size: Vector2(
          _labelSize.x + configs.smallMargin + _buttonsPanelSize.x,
          configs.smallBtnSize.y,
        ),
        alignedChildren: {
          Anchor.topLeft: _createLabel("Turn Direction:"),
          Anchor.topRight: _turnDirPanel = MultiAlignComponent(
            size: Vector2(
              configs.smallBtnSize.x * 2 + configs.smallMargin,
              configs.smallBtnSize.y,
            ),
            alignedChildren: {
              Anchor.topLeft: OptionButton(
                icon: Icons.rotate_right,
                fontSize: configs.iconFontSize,
                size: configs.smallBtnSize,
                onSelect: () => _setTurnDirection(TurnDirection.clockwise),
              ),
              Anchor.topRight: OptionButton(
                icon: Icons.rotate_left,
                fontSize: configs.iconFontSize,
                size: configs.smallBtnSize,
                onSelect: () => _setTurnDirection(TurnDirection.anticlockwise),
              ),
            },
          ),
        },
      );

  Component _createStartIdeology() =>
      MultiAlignComponent(
        position: Vector2(0, configs.smallBtnSize.y + configs.largeMargin),
        size: Vector2(
          _labelSize.x + configs.smallMargin + _buttonsPanelSize.x,
          _buttonsPanelSize.y,
        ),
        alignedChildren: {
          Anchor.topLeft: _createLabel("Start Player:"),
          Anchor.topRight: _startIdeologyPanel = MultiAlignComponent(
            size: _buttonsPanelSize,
            alignedChildren: _ideologyAnchor.map((ideology, anchor) => MapEntry(
              anchor,
              OptionButton(
                text: ideology.name[0].toUpperCase(),
                size: configs.smallBtnSize,
                onSelect: () => _setStartIdeology(ideology),
              ),
            )),
          ),
        },
      );

  Component _createHumanPlayers() =>
      MultiAlignComponent(
        position: Vector2(0, configs.smallBtnSize.y + _buttonsPanelSize.y + 2 * configs.largeMargin),
        size: Vector2(
          _labelSize.x + configs.smallMargin + _buttonsPanelSize.x,
          _buttonsPanelSize.y,
        ),
        alignedChildren: {
          Anchor.topLeft: _createLabel("Human Players:"),
          Anchor.topRight: _humanPlayersPanel = MultiAlignComponent(
            position: Vector2(_labelSize.x + configs.smallMargin, 0),
            size: _buttonsPanelSize,
            alignedChildren: _ideologyAnchor.map((ideology, anchor) => MapEntry(
              anchor,
              ToggleButton(
                text: ideology.name[0].toUpperCase(),
                size: configs.smallBtnSize,
                onSelectedChanged: (value) {
                  game.options.players[ideology] =
                  value ? PlayerType.human : PlayerType.aiMaxN;
                },
              ),
            )),
          ),
        },
      );

  PositionComponent _createLabel(String text, {Vector2? position}) =>
      TextBoxComponent(
        size: _labelSize,
        position: position,
        text: text,
        align: Anchor.centerRight,
        textRenderer: getRenderer(),
      );

  void _setTurnDirection(TurnDirection direction) {
    game.options.turnDirection = direction;
    final buttons = _turnDirPanel.alignedChildren.values.cast<OptionButton>();
    updateSelections(direction.index, buttons);
  }

  void _setStartIdeology(Ideology ideology) {
    game.options.startIdeology = ideology;
    final buttons = _startIdeologyPanel.alignedChildren.values.cast<OptionButton>();
    updateSelections(ideology.index, buttons);
  }

  void _showHumanPlayers() {
    final buttons = _humanPlayersPanel.alignedChildren.values.cast<ToggleButton>();
    for (final (i, button) in buttons.indexed) {
      final ideology = Ideology.values[i];
      button.isSelected = game.options.players[ideology]!.isHuman;
    }
  }
}
