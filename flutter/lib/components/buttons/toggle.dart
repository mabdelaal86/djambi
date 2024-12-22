import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../configs.dart' as configs;
import '../utils.dart';
import 'base.dart';

class ToggleButton extends ToggleButtonComponent {
  final String? text;
  final IconData? icon;
  final ButtonColorSchema colorSchema;
  final ButtonColorSchema selectedColorSchema;
  final double fontSize;

  ToggleButton({
    required super.onSelectedChanged,
    this.text,
    this.icon,
    super.position,
    required super.size,
    this.colorSchema = configs.secondaryBtnColors,
    this.selectedColorSchema = configs.primaryBtnColors,
    this.fontSize = configs.defaultFontSize,
    super.anchor = Anchor.topLeft,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    defaultLabel = defaultSelectedLabel = TextComponent(
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
    defaultSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.natural);
    hoverAndSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.hover);
    downAndSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.down);
  }
}
