import 'dart:ui';

import 'package:flame/components.dart';

import '../../common/utils.dart';
import '../../views/theme.dart';
import '../buttons.dart';
import '../configs.dart' as configs;
import '../header.dart';
import '../utils.dart';
import 'base.dart';

final _sectionLabelSize = Vector2(200, configs.smallBtnSize.y);
final _marginsPanelSize = Vector2(
  configs.mediumBtnSize.x * 3 + configs.smallMargin * 2,
  _sectionLabelSize.y + configs.mediumBtnSize.y + configs.smallMargin,
);

class SettingsPage extends BasePage {
  // @override
  // bool get debugMode => true;

  late final OptionButton _marginsNone, _marginsHalf, _marginsFull;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Header(title: "Settings", onBackTapUp: onBackTapUp),
      PositionComponent(
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
        size: _marginsPanelSize,
        children: [
          _createMarginsSettings(),
        ],
      ),
    ]);
    _setMarginsVisibility(game.settings.showMargins);
  }

  Component _createMarginsSettings() => PositionComponent(
        position: Vector2.zero(),
        size: _marginsPanelSize,
        children: [
          _createSectionLabel("Margins:"),
          _marginsNone = OptionButton(
            text: "None",
            size: configs.mediumBtnSize,
            position: Anchor.bottomLeft.ofSize(_marginsPanelSize),
            anchor: Anchor.bottomLeft,
            onSelect: () => _setMarginsVisibility(MarginsVisibility.none),
          ),
          _marginsHalf = OptionButton(
            text: "Top-Left",
            size: configs.mediumBtnSize,
            position: Anchor.bottomCenter.ofSize(_marginsPanelSize),
            anchor: Anchor.bottomCenter,
            onSelect: () => _setMarginsVisibility(MarginsVisibility.half),
          ),
          _marginsFull = OptionButton(
            text: "Full",
            size: configs.mediumBtnSize,
            position: Anchor.bottomRight.ofSize(_marginsPanelSize),
            anchor: Anchor.bottomRight,
            onSelect: () => _setMarginsVisibility(MarginsVisibility.full),
          ),
        ],
      );

  Component _createSectionLabel(String text, {Vector2? position}) =>
      PositionComponent(
        size: _sectionLabelSize,
        position: position,
        children: [
          TextComponent(
            text: text,
            textRenderer: getRenderer(fontWeight: FontWeight.bold),
            anchor: Anchor.centerLeft,
            position: Anchor.centerLeft.ofSize(_sectionLabelSize),
          ),
        ],
      );

  void _setMarginsVisibility(MarginsVisibility visibility) {
    game.settings.showMargins = visibility;
    _marginsNone.isSelected = visibility == MarginsVisibility.none;
    _marginsHalf.isSelected = visibility == MarginsVisibility.half;
    _marginsFull.isSelected = visibility == MarginsVisibility.full;
  }

  Future<void> onBackTapUp() async {
    await game.settings.save();
    game.router.pop();
  }
}
