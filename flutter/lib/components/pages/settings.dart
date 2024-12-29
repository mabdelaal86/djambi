import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../common/utils.dart';
import '../../views/theme.dart';
import '../buttons.dart';
import '../configs.dart' as configs;
import '../header.dart';
import '../layouts.dart';
import '../utils.dart';
import 'base.dart';

final _sectionLabelSize = Vector2(200, configs.smallBtnSize.y);

class SettingsPage extends BasePage {
  // @override
  // bool get debugMode => true;

  late final List<OptionButton> _marginsButtons;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Header(title: "Settings", onBackTapUp: _onBackTapUp),
      FlexComponent(
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
        spacing: configs.largeMargin,
        children: [
          _createMarginsPanel(),
        ],
      ),
    ]);
    _setMarginsVisibility(game.settings.showMargins);
  }

  PositionComponent _createMarginsPanel() =>
      FlexComponent(
        spacing: configs.smallMargin,
        children: [
          _createSectionLabel("Margins:"),
          FlexComponent(
            axis: Axis.horizontal,
            spacing: configs.smallMargin,
            children: _marginsButtons = [
              OptionButton(
                text: "None",
                size: configs.mediumBtnSize,
                onSelect: () => _setMarginsVisibility(MarginsVisibility.none),
              ),
              OptionButton(
                text: "Top-Left",
                size: configs.mediumBtnSize,
                onSelect: () => _setMarginsVisibility(MarginsVisibility.half),
              ),
              OptionButton(
                text: "Full",
                size: configs.mediumBtnSize,
                onSelect: () => _setMarginsVisibility(MarginsVisibility.full),
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
        textRenderer: getRenderer(fontWeight: FontWeight.bold),
      );

  void _setMarginsVisibility(MarginsVisibility visibility) {
    game.settings.showMargins = visibility;
    updateSelections(visibility.index, _marginsButtons);
  }

  Future<void> _onBackTapUp() async {
    await game.settings.save();
    game.router.pop();
  }
}
