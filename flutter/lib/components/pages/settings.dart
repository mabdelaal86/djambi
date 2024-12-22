import 'dart:ui';

import 'package:flame/components.dart';

import '../../common/utils.dart';
import '../../views/theme.dart';
import '../buttons/option.dart';
import '../configs.dart' as configs;
import '../header.dart';
import '../layout.dart';
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

  late final Component _marginsVisibility;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Header(title: "Settings", onBackTapUp: onBackTapUp),
      _marginsVisibility = MultiAlignComponent(
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
        size: _marginsPanelSize,
        alignedChildren: {
          Anchor.topLeft: _createSectionLabel("Margins:"),
          Anchor.bottomLeft: OptionButton(
            text: "None",
            size: configs.mediumBtnSize,
            onSelect: () => _setMarginsVisibility(MarginsVisibility.none),
          ),
          Anchor.bottomCenter: OptionButton(
            text: "Top-Left",
            size: configs.mediumBtnSize,
            onSelect: () => _setMarginsVisibility(MarginsVisibility.half),
          ),
          Anchor.bottomRight: OptionButton(
            text: "Full",
            size: configs.mediumBtnSize,
            onSelect: () => _setMarginsVisibility(MarginsVisibility.full),
          ),
        },
      ),
    ]);
    _setMarginsVisibility(game.settings.showMargins);
  }

  PositionComponent _createSectionLabel(String text) =>
      TextBoxComponent(
        size: _sectionLabelSize,
        text: text,
        align: Anchor.centerLeft,
        textRenderer: getRenderer(fontWeight: FontWeight.bold),
      );

  void _setMarginsVisibility(MarginsVisibility visibility) {
    game.settings.showMargins = visibility;
    updateSelections(visibility.index, _marginsVisibility.children.whereType());
  }

  Future<void> onBackTapUp() async {
    await game.settings.save();
    game.router.pop();
  }
}
