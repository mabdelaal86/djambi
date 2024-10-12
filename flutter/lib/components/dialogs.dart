import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'buttons.dart';
import 'game.dart';

class ConfirmDialog extends ValueRoute<bool> with HasGameReference<DjambiGame> {
  ConfirmDialog(this.text) : super(value: false);
  final String text;

  @override
  Component build() {
    return RectangleComponent(
      size: Vector2(600, 300),
      position: game.size / 2,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0x44ff0000),
      children: [
        TextBoxComponent(
          text: text,
          anchor: Anchor.center,
          align: Anchor.center,
          size: Vector2(550, 150),
          position: Vector2(300, 100),
        ),
        RoundedButton(
          text: 'Yes',
          size: Vector2(250, 75),
          onReleased: () => completeWith(true),
          position: Vector2(150, 200),
        ),
        RoundedButton(
          text: 'No',
          size: Vector2(250, 75),
          onReleased: () => completeWith(false),
          position: Vector2(450, 200),
        ),
      ],
    );
  }
}
