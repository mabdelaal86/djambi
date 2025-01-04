import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';

import 'configs.dart';

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

TextPaint getTextRenderer({
  double fontSize = Configs.defaultFontSize,
  Color color = Configs.textColor,
  String? fontFamily, FontWeight? fontWeight, FontStyle? fontStyle
}) => TextPaint(
  style: TextStyle(
    color: color,
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
  ),
);

void updateSelections(int value, Iterable<ToggleButtonComponent> buttons) {
  for (final (i, button) in buttons.indexed) {
    button.isSelected = i == value;
  }
}
