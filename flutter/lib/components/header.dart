import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';
import 'configs.dart' as configs;
import 'game.dart';

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
      AlignComponent(
        alignment: Anchor.center,
        child: TextComponent(text: title),
      ),
      if (game.router.previousRoute != null)
        RoundedButton(
          icon: Icons.arrow_back,
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
