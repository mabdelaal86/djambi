import 'dart:ui';

import 'package:flame/text.dart';

class ButtonColorSchema {
  final Color natural;
  final Color hover;
  final Color down;
  final Color disabled;
  final Color text;

  const ButtonColorSchema(
      this.natural,
      this.hover,
      this.down,
      this.disabled,
      this.text,
  );
}

TextPaint getRenderer(double fontSize, Color color, [String? fontFamily]) => TextPaint(
  style: TextStyle(
    color: color,
    fontFamily: fontFamily,
    fontSize: fontSize,
  ),
);
