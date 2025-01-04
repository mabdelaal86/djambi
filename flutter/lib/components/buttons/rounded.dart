import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../common/utils.dart';
import '../configs.dart';
import '../utils.dart';
import 'base.dart';

class RoundedButton extends AdvancedButtonComponent {
  final String? text;
  final IconData? icon;
  final ButtonColorSchema colorSchema;
  final double fontSize;

  RoundedButton({
    this.text,
    this.icon,
    required super.size,
    super.position,
    required super.onReleased,
    this.colorSchema = Configs.primaryBtnColors,
    this.fontSize = Configs.defaultFontSize,
    super.anchor = Anchor.topLeft,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    defaultLabel = TextComponent(
      text: icon?.codePoint.convert(String.fromCharCode) ?? text,
      textRenderer: getTextRenderer(
          fontSize: fontSize,
          color: colorSchema.text,
          fontFamily: icon?.fontFamily,
      ),
    );
    defaultSkin = RoundedRectComponent()..setColor(colorSchema.natural);
    hoverSkin = RoundedRectComponent()..setColor(colorSchema.hover);
    downSkin = RoundedRectComponent()..setColor(colorSchema.down);
    disabledSkin = RoundedRectComponent()..setColor(colorSchema.disabled);
  }
}
