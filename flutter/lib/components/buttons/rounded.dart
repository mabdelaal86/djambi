import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../configs.dart' as configs;
import '../utils/ui.dart';
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
    this.colorSchema = configs.primaryBtnColors,
    this.fontSize = configs.defaultFontSize,
    super.anchor = Anchor.topLeft,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    defaultLabel = TextComponent(
      text: icon == null ? text : String.fromCharCode(icon!.codePoint),
      textRenderer: getRenderer(
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
