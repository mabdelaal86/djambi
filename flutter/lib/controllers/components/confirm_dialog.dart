import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../common/utils.dart';
import '../game.dart';
import 'multi_align.dart';
import 'rounded_button.dart';
import 'rounded_rect.dart';
import 'utils.dart';

class ConfirmDialog extends ValueRoute<String> with HasGameReference<DjambiGame> {
  final String message, leftText, rightText;

  ConfirmDialog(
      this.message,
      [this.leftText = "Yes", this.rightText = "No"])
      : super(value: "");

  static final _dialogSize = Vector2(600, 300);
  static const _margin = 20.0;

  @override
  Component build() => RoundedRectComponent(
    size: _dialogSize,
    position: game.size / 2,
    anchor: Anchor.center,
    paint: const Color(0xFF882222).toPaint(),
    radius: const Radius.circular(50),
    children: [
      MultiAlignComponent(
        size: _dialogSize,
        padding: const EdgeInsets.all(_margin),
        alignedChildren: {
          Anchor.topCenter: TextBoxComponent(
            text: message,
            size: Vector2(550, 150),
            align: Anchor.center,
            textRenderer: getTextRenderer(),
          ),
          Anchor.bottomLeft: RoundedButton(
            text: leftText,
            size: Vector2(250, 75),
            onReleased: () => completeWith(leftText),
          ),
          Anchor.bottomRight: RoundedButton(
            text: rightText,
            size: Vector2(250, 75),
            onReleased: () => completeWith(rightText),
          ),
        },
      ),
    ],
  );
}
