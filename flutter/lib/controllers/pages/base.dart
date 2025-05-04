import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../common/utils.dart';
import '../components.dart';
import '../configs.dart';
import '../game.dart';

abstract class BasePage extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  final String title;

  BasePage({this.title = "Djambi"});

  @override
  @mustCallSuper
  Future<void> onLoad() async {
    size = game.size;
    await add(_header());
  }

  void onBackTapUp() => game.router.pop();

  // Body area without header
  Vector2 get bodyPosition => Vector2(0, Configs.headerSize.y);
  Vector2 get bodySize => size - bodyPosition;

  PositionComponent _header() => PositionComponent(
    size: Configs.headerSize,
    children: [
      TextComponent(
        text:  title,
        textRenderer: getTextRenderer(fontSize: Configs.headerFontSize),
        anchor: Anchor.center,
        position: Anchor.center.ofSize(Configs.headerSize),
      ),
      if (game.router.previousRoute != null)
        RoundedButton(
          icon: Icons.arrow_back,
          fontSize: Configs.iconFontSize,
          position: Vector2.all(Configs.headerSize.y / 2),
          anchor: Anchor.center,
          size: Configs.smallBtnSize,
          onReleased: onBackTapUp,
        ),
    ]
  );
}

void updateSelections(int value, Iterable<ToggleButtonComponent> buttons) {
  for (final (i, button) in buttons.indexed) {
    button.isSelected = i == value;
  }
}
