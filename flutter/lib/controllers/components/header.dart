import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../common/utils.dart';
import '../configs.dart';
import '../game.dart';
import 'rounded_button.dart';
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
    size = Configs.headerSize;
    await addAll([
      TextComponent(
        text:  title,
        textRenderer: getTextRenderer(fontSize: Configs.headerFontSize),
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
      ),
      if (game.router.previousRoute != null)
        RoundedButton(
          icon: Icons.arrow_back,
          fontSize: Configs.iconFontSize,
          position: Vector2.all(Configs.headerSize.y / 2),
          anchor: Anchor.center,
          size: Configs.smallBtnSize,
          onReleased: () => switch (onBackTapUp) {
            null => game.router.pop(),
            final fun => fun.call(),
          },
        ),
    ]);
  }
}
