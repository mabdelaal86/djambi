import 'dart:ui';

import 'package:flame/text.dart';

class ButtonColorSchema {
  final Color natural;
  final Color hover;
  final Color down;
  final Color disabled;

  const ButtonColorSchema(
    this.natural,
    this.hover,
    this.down,
    this.disabled,
  );
}

TextPaint getRenderer(double fontSize, [String? fontFamily]) => TextPaint(
  style: TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
  ),
);
