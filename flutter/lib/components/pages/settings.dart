import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../common/utils.dart';
import '../../views.dart';
import '../buttons.dart';
import '../configs.dart';
import '../header.dart';
import '../layouts.dart';
import '../preferences.dart';
import '../utils.dart';
import 'base.dart';

final _sectionLabelSize = Vector2(200, Configs.smallBtnSize.y);

class SettingsPage extends BasePage {
  // @override
  // bool get debugMode => true;

  late final List<OptionButton> _marginsButtons;
  late final Preferences _prefs;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _prefs = await Preferences.getInstance();
    await addAll([
      Header(title: "Settings"),
      FlexComponent(
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
        spacing: Configs.largeMargin,
        children: [
          _createMarginsPanel(),
        ],
      ),
    ]);
    _getMarginsVisibility();
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

  PositionComponent _createSectionLabel(String text) =>
      TextBoxComponent(
        size: _sectionLabelSize,
        text: text,
        align: Anchor.centerLeft,
        textRenderer: getTextRenderer(fontWeight: FontWeight.bold),
      );

  Future<void> _setMarginsVisibility(MarginsVisibility visibility) async {
    await _prefs.setMarginsVisibility(visibility);
    updateSelections(visibility.index, _marginsButtons);
  }

  void _getMarginsVisibility() {
    updateSelections(_prefs.getMarginsVisibility().index, _marginsButtons);
  }
}
