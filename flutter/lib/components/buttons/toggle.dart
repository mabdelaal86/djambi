import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../common/utils.dart';
import '../configs.dart';
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
    this.colorSchema = Configs.secondaryBtnColors,
    this.selectedColorSchema = Configs.primaryBtnColors,
    this.fontSize = Configs.defaultFontSize,
    super.anchor = Anchor.topLeft,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    defaultLabel = defaultSelectedLabel = TextComponent(
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
    defaultSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.natural);
    hoverAndSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.hover);
    downAndSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.down);
    disabledAndSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.disabled);
  }
}
