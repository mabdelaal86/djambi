import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart';

import '../configs.dart' as configs;
import 'toggle.dart';

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
