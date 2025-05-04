import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../common/utils.dart';
import '../../views.dart';
import '../components.dart';
import '../configs.dart';
import '../preferences.dart';
import 'base.dart';

final _sectionLabelSize = Vector2(400, Configs.smallBtnSize.y);

class SettingsPage extends BasePage {
  // @override
  // bool get debugMode => true;

  SettingsPage(): super(title: "Settings");

  late final List<OptionButton> _marginsButtons;
  late final List<OptionButton> _gameSpeedButtons;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      FlexComponent(
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
        spacing: Configs.largeMargin,
        children: [
          _createMarginsPanel(),
          _createGameSpeedPanel(),
        ],
      ),
    ]);
    _getMarginsVisibility();
    _getGameSpeed();
  }

  PositionComponent _createMarginsPanel() =>
      FlexComponent(
        spacing: Configs.smallMargin,
        children: [
          _createSectionLabel("Margins:"),
          FlexComponent(
            axis: Axis.horizontal,
            spacing: Configs.smallMargin,
            children: _marginsButtons = [
              OptionButton(
                text: "None",
                size: Configs.mediumBtnSize,
                onSelect: () async => _setMarginsVisibility(MarginsVisibility.none),
              ),
              OptionButton(
                text: "Top-Left",
                size: Configs.mediumBtnSize,
                onSelect: () async => _setMarginsVisibility(MarginsVisibility.half),
              ),
              OptionButton(
                text: "Full",
                size: Configs.mediumBtnSize,
                onSelect: () async => _setMarginsVisibility(MarginsVisibility.full),
              ),
            ],
          ),
        ],
      );

  PositionComponent _createGameSpeedPanel() =>
      FlexComponent(
        spacing: Configs.smallMargin,
        children: [
          _createSectionLabel("Game Speed:"),
          FlexComponent(
            axis: Axis.horizontal,
            spacing: Configs.smallMargin,
            children: _gameSpeedButtons = [
              OptionButton(
                text: "Fast",
                size: Configs.mediumBtnSize,
                onSelect: () async => _setGameSpeed(GameSpeed.fast),
              ),
              OptionButton(
                text: "Medium",
                size: Configs.mediumBtnSize,
                onSelect: () async => _setGameSpeed(GameSpeed.medium),
              ),
              OptionButton(
                text: "Slow",
                size: Configs.mediumBtnSize,
                onSelect: () async => _setGameSpeed(GameSpeed.slow),
              ),
            ],
          ),
        ],
      );

  PositionComponent _createSectionLabel(String text) =>
      TextBoxComponent(
        size: _sectionLabelSize,
        text: text,
        align: Anchor.centerLeft,
        textRenderer: getTextRenderer(fontWeight: FontWeight.bold),
      );

  Future<void> _setMarginsVisibility(MarginsVisibility visibility) async {
    await game.prefs.setMarginsVisibility(visibility);
    updateSelections(visibility.index, _marginsButtons);
  }

  void _getMarginsVisibility() {
    updateSelections(game.prefs.getMarginsVisibility().index, _marginsButtons);
  }

  Future<void> _setGameSpeed(GameSpeed gameSpeed) async {
    await game.prefs.setGameSpeed(gameSpeed);
    updateSelections(gameSpeed.index, _gameSpeedButtons);
  }

  void _getGameSpeed() {
    updateSelections(game.prefs.getGameSpeed().index, _gameSpeedButtons);
  }
}
