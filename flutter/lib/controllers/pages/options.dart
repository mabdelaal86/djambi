import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../models.dart';
import '../components.dart';
import '../configs.dart';
import 'base.dart';

const _ideologyAnchor = {
  Ideology.red: Anchor.bottomLeft,
  Ideology.blue: Anchor.bottomRight,
  Ideology.yellow: Anchor.topRight,
  Ideology.green: Anchor.topLeft,
};

final _labelSize = Vector2(250, Configs.smallBtnSize.y);
final _buttonsPanelSize = (Configs.smallBtnSize * 2) +
    Vector2.all(Configs.smallMargin);

class OptionsPage extends BasePage {
  // @override
  // bool get debugMode => true;

  late final MultiAlignComponent _turnDirectionPanel;
  late final MultiAlignComponent _startIdeologyPanel;
  late final MultiAlignComponent _humanPlayersPanel;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await addAll([
      Header(),
      MultiAlignComponent(
        size: size,
        padding: const EdgeInsets.all(Configs.largeMargin),
        alignedChildren: {
          Anchor.center: FlexComponent(
            spacing: Configs.largeMargin,
            children: [
              _createTurnDirectionPanel(),
              _createStartIdeologyPanel(),
              _createHumanPlayersPanel(),
            ],
          ),
          Anchor.bottomCenter: RoundedButton(
            text: "Play",
            size: Configs.largeBtnSize,
            onReleased: () => game.router.pushReplacementNamed("play"),
          ),
        },
      ),
    ]);
    _getTurnDirection();
    _getStartIdeology();
    _getPlayerTypes();
  }

  PositionComponent _createTurnDirectionPanel() =>
      FlexComponent(
        spacing: Configs.smallMargin,
        axis: Axis.horizontal,
        children: [
          _createLabel("Turn Direction:"),
          _turnDirectionPanel = MultiAlignComponent(
            size: Vector2(_buttonsPanelSize.x, Configs.smallBtnSize.y),
            alignedChildren: {
              Anchor.topLeft: OptionButton(
                icon: Icons.rotate_right,
                fontSize: Configs.iconFontSize,
                size: Configs.smallBtnSize,
                onSelect: () async => _setTurnDirection(TurnDirection.clockwise),
              ),
              Anchor.topRight: OptionButton(
                icon: Icons.rotate_left,
                fontSize: Configs.iconFontSize,
                size: Configs.smallBtnSize,
                onSelect: () async => _setTurnDirection(TurnDirection.anticlockwise),
              ),
            },
          ),
        ],
      );

  PositionComponent _createStartIdeologyPanel() =>
      FlexComponent(
        spacing: Configs.smallMargin,
        axis: Axis.horizontal,
        children: [
          _createLabel("Start Player:"),
          _startIdeologyPanel = MultiAlignComponent(
            size: _buttonsPanelSize,
            alignedChildren: _ideologyAnchor.map((ideology, anchor) => MapEntry(
              anchor,
              OptionButton(
                text: ideology.name[0].toUpperCase(),
                size: Configs.smallBtnSize,
                onSelect: () async => _setStartIdeology(ideology),
              ),
            )),
          ),
        ],
      );

  PositionComponent _createHumanPlayersPanel() =>
      FlexComponent(
        spacing: Configs.smallMargin,
        axis: Axis.horizontal,
        children: [
          _createLabel("Human Players:"),
          _humanPlayersPanel = MultiAlignComponent(
            size: _buttonsPanelSize,
            alignedChildren: _ideologyAnchor.map((ideology, anchor) => MapEntry(
              anchor,
              ToggleButton(
                text: ideology.name[0].toUpperCase(),
                size: Configs.smallBtnSize,
                onSelectedChanged: (_) async => _setPlayerTypes(),
              ),
            )),
          ),
        ],
      );

  PositionComponent _createLabel(String text, {Vector2? position}) =>
      TextBoxComponent(
        size: _labelSize,
        position: position,
        text: text,
        align: Anchor.centerRight,
        textRenderer: getTextRenderer(),
      );

  Future<void> _setTurnDirection(TurnDirection direction) async {
    final buttons = _turnDirectionPanel.alignedChildren.values.cast<OptionButton>();
    await game.prefs.setTurnDirection(direction);
    updateSelections(direction.index, buttons);
  }

  void _getTurnDirection() {
    final buttons = _turnDirectionPanel.alignedChildren.values.cast<OptionButton>();
    updateSelections(game.prefs.getTurnDirection().index, buttons);
  }

  Future<void> _setStartIdeology(Ideology ideology) async {
    final buttons = _startIdeologyPanel.alignedChildren.values.cast<OptionButton>();
    await game.prefs.setStartIdeology(ideology);
    updateSelections(ideology.index, buttons);
  }

  void _getStartIdeology() {
    final buttons = _startIdeologyPanel.alignedChildren.values.cast<OptionButton>();
    updateSelections(game.prefs.getStartIdeology().index, buttons);
  }

  Future<void> _setPlayerTypes() async {
    final buttons = _humanPlayersPanel.alignedChildren.values.cast<ToggleButton>();
    final playerTypes = buttons
        .map((b) => b.isSelected ? PlayerType.human : PlayerType.aiMaxN);
    await game.prefs.setPlayerTypes(playerTypes);
  }

  void _getPlayerTypes() {
    final buttons = _humanPlayersPanel.alignedChildren.values.cast<ToggleButton>();
    final playerTypes = game.prefs.getPlayerTypes();
    for (final (i, button) in buttons.indexed) {
      button.isSelected = playerTypes[i].isHuman;
    }
  }
}
