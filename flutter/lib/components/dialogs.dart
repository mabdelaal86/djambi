import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../common/utils.dart';
import 'buttons.dart';
import 'game.dart';
import 'utils.dart';

class ConfirmDialog extends ValueRoute<bool> with HasGameReference<DjambiGame> {
  ConfirmDialog(this.text) : super(value: false);
  final String text;

  static final _dialogSize = Vector2(600, 300);
  static const _margin = 20.0;

  @override
  Component build() => RectangleComponent(
    size: _dialogSize,
    position: game.size / 2,
    anchor: Anchor.center,
    paint: Paint()..color = const Color(0x44FF0000),
    children: [
      TextBoxComponent(
        text: text,
        anchor: Anchor.center,
        align: Anchor.center,
        size: Vector2(550, 150),
        position: Vector2(300, 100),
        textRenderer: getRenderer(),
      ),
      RoundedButton(
        text: 'Yes',
        size: Vector2(250, 75),
        onReleased: () => completeWith(true),
        anchor: Anchor.bottomLeft,
        position: Anchor.bottomLeft.ofSize(_dialogSize) +
            Vector2(_margin, -_margin),
      ),
      RoundedButton(
        text: 'No',
        size: Vector2(250, 75),
        onReleased: () => completeWith(false),
        anchor: Anchor.bottomRight,
        position: Anchor.bottomRight.ofSize(_dialogSize) +
            Vector2(-_margin, -_margin),
      ),
    ],
  );
}
