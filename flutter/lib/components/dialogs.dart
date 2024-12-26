import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';
import 'game.dart';
import 'layout.dart';
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
      MultiAlignComponent(
        size: _dialogSize,
        padding: const EdgeInsets.all(_margin),
        alignedChildren: {
          Anchor.topCenter: TextBoxComponent(
            text: text,
            size: Vector2(550, 150),
            align: Anchor.center,
            textRenderer: getRenderer(),
          ),
          Anchor.bottomLeft: RoundedButton(
            text: 'Yes',
            size: Vector2(250, 75),
            onReleased: () => completeWith(true),
          ),
          Anchor.bottomRight: RoundedButton(
            text: 'No',
            size: Vector2(250, 75),
            onReleased: () => completeWith(false),
          ),
        },
      ),
    ],
  );
}
