import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../common/utils.dart';
import '../configs.dart';
import 'rounded_rect.dart';
import 'utils.dart';

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
    defaultSkin = RoundedRectComponent(paint: colorSchema.natural.toPaint());
    hoverSkin = RoundedRectComponent(paint: colorSchema.hover.toPaint());
    downSkin = RoundedRectComponent(paint: colorSchema.down.toPaint());
    disabledSkin = RoundedRectComponent(paint: colorSchema.disabled.toPaint());
    defaultSelectedSkin = RoundedRectComponent(paint: selectedColorSchema.natural.toPaint());
    hoverAndSelectedSkin = RoundedRectComponent(paint: selectedColorSchema.hover.toPaint());
    downAndSelectedSkin = RoundedRectComponent(paint: selectedColorSchema.down.toPaint());
    disabledAndSelectedSkin = RoundedRectComponent(paint: selectedColorSchema.disabled.toPaint());
  }
}
