import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

class RoundedButton extends AdvancedButtonComponent {
  static final Vector2 defaultSize = Vector2.all(50);

  final String? text;
  final IconData? icon;
  final Color defaultColor;
  final Color hoverColor;
  final Color downColor;
  final Color disabledColor;

  RoundedButton({
    this.text,
    this.icon,
    required super.size,
    super.position,
    required super.onReleased,
    this.defaultColor = const Color(0xFF00C800),
    this.hoverColor = const Color(0xFF00B400),
    this.downColor = const Color(0xFF006400),
    this.disabledColor = const Color(0xFF646464),
    super.anchor = Anchor.center,
  });

  static TextComponent createLabel(IconData? icon, String? text) {
    if (icon == null) {
      return TextComponent(text: text);
    }

    return TextComponent(
      text: String.fromCharCode(icon.codePoint),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 32,
          fontFamily: icon.fontFamily,
        ),
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    defaultLabel = createLabel(icon, text);
    defaultSkin = RoundedRectComponent()..setColor(defaultColor);
    hoverSkin = RoundedRectComponent()..setColor(hoverColor);
    downSkin = RoundedRectComponent()..setColor(downColor);
    disabledSkin = RoundedRectComponent()..setColor(disabledColor);
  }
}

class ToggleButton extends ToggleButtonComponent {
  final String? text;
  final IconData? icon;
  final Color defaultColor;
  final Color hoverColor;
  final Color downColor;
  final Color defaultSelectedColor;
  final Color hoverSelectedColor;
  final Color downSelectedColor;

  ToggleButton({
    required super.onSelectedChanged,
    this.text,
    this.icon,
    required super.size,
    this.defaultColor = const Color(0xFF00C800),
    this.hoverColor = const Color(0xFF00B400),
    this.downColor = const Color(0xFF006400),
    this.defaultSelectedColor = const Color(0xFF0000C8),
    this.hoverSelectedColor = const Color(0xFF0000B4),
    this.downSelectedColor = const Color(0xFF000064),
    super.anchor = Anchor.center,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    defaultLabel = defaultSelectedLabel = RoundedButton.createLabel(icon, text);
    defaultSkin = RoundedRectComponent()..setColor(defaultColor);
    hoverSkin = RoundedRectComponent()..setColor(hoverColor);
    downSkin = RoundedRectComponent()..setColor(downColor);
    defaultSelectedSkin = RoundedRectComponent()..setColor(defaultSelectedColor);
    hoverAndSelectedSkin = RoundedRectComponent()..setColor(hoverSelectedColor);
    downAndSelectedSkin = RoundedRectComponent()..setColor(downSelectedColor);
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
    required super.size,
    super.defaultColor = const Color(0x4400C800),
    super.hoverColor = const Color(0x4400B400),
    super.downColor = const Color(0x44006400),
    super.defaultSelectedColor = const Color(0xFF00C800),
    super.hoverSelectedColor = const Color(0xFF00B400),
    super.downSelectedColor = const Color(0xFF006400),
    super.anchor = Anchor.center,
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
