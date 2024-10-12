import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';
import 'game.dart';

class Header extends PositionComponent with HasGameReference<DjambiGame> {
  final String title;
  final VoidCallback? onBackTapUp;

  late final TextComponent _text;

  Header({
    this.title = "Djambi",
    this.onBackTapUp,
  });

  @override
  Future<void> onLoad() async {
    await addAll([
      _text = TextComponent(
        text: title,
        anchor: Anchor.center,
      ),
      if (game.router.previousRoute != null)
        RoundedButton(
          icon: Icons.arrow_back,
          position: Vector2(50, 50),
          size: RoundedButton.defaultSize,
          onReleased: () => switch(onBackTapUp) {
            null => game.router.pop(),
            final fun => fun.call(),
          },
        ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = Vector2(size.x, 100);
    _text.position = this.size / 2;
  }
}
