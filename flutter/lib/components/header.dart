import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../common/utils.dart';
import 'buttons.dart';
import 'configs.dart' as configs;
import 'game.dart';
import 'utils.dart';

class Header extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  final String title;
  final VoidCallback? onBackTapUp;

  Header({
    this.title = "Djambi",
    this.onBackTapUp,
  });

  @override
  Future<void> onLoad() async {
    size = configs.headerSize;
    await addAll([
      TextComponent(
        text:  title,
        textRenderer: getRenderer(configs.headerFontSize),
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
      ),
      if (game.router.previousRoute != null)
        RoundedButton(
          icon: Icons.arrow_back,
          fontSize: configs.iconFontSize,
          position: Vector2.all(configs.headerSize.y / 2),
          anchor: Anchor.center,
          size: configs.smallBtnSize,
          onReleased: () => switch(onBackTapUp) {
            null => game.router.pop(),
            final fun => fun.call(),
          },
        ),
    ]);
  }
}
