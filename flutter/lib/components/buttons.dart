import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

import 'configs.dart' as configs;
import 'utils.dart';

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
      textRenderer: getRenderer(fontSize, icon?.fontFamily),
    );
    defaultSkin = RoundedRectComponent()..setColor(colorSchema.natural);
    hoverSkin = RoundedRectComponent()..setColor(colorSchema.hover);
    downSkin = RoundedRectComponent()..setColor(colorSchema.down);
    disabledSkin = RoundedRectComponent()..setColor(colorSchema.disabled);
  }
}

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
      textRenderer: getRenderer(fontSize, icon?.fontFamily),
    );
    defaultSkin = RoundedRectComponent()..setColor(colorSchema.natural);
    hoverSkin = RoundedRectComponent()..setColor(colorSchema.hover);
    downSkin = RoundedRectComponent()..setColor(colorSchema.down);
    defaultSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.natural);
    hoverAndSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.hover);
    downAndSelectedSkin = RoundedRectComponent()..setColor(selectedColorSchema.down);
  }
}

class OptionButton extends ToggleButton {
  VoidCallback onSelect;
  bool _selectable = true;

  OptionButton({
    required this.onSelect,
    super.onSelectedChanged,
    super.text,
    super.icon,
    super.position,
    required super.size,
    super.colorSchema = configs.secondaryBtnColors,
    super.selectedColorSchema = configs.primaryBtnColors,
    super.fontSize = configs.defaultFontSize,
    super.anchor = Anchor.topLeft,
  });

  @override
  void onTapUp(TapUpEvent event) {
    if (!isSelected) {
      onSelect.call();
    }
    _selectable = false;
    super.onTapUp(event);
    _selectable = true;
  }

  @override
  set isSelected(bool value) {
    if (_selectable) {
      super.isSelected = value;
    }
  }
}

class RoundedRectComponent extends PositionComponent with HasPaint {
  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          size.toRect(),
          Radius.circular(height / 2)
      ),
      paint,
    );
  }
}
