import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart' show SystemMouseCursors;

mixin Hoverable on PositionComponent {
  bool onHoverEnter(PointerHoverInfo info) => false;
  bool onHoverExit(PointerHoverInfo info) => false;
}

class DropdownButton extends PositionComponent
    with TapCallbacks, Hoverable, HasGameRef {
  final String label;
  final List<String> items;
  final Paint paint;
  final void Function(String) onItemSelected;
  final void Function()? onHover;
  final void Function()? onExit;
  final RRect _rect;
  bool _isExpanded = false;
  late final TextComponent _labelComponent;
  late final List<TextComponent> _itemComponents;

  DropdownButton({
    required this.label,
    required this.items,
    required this.onItemSelected,
    this.onHover,
    this.onExit,
    Color color = const Color(0xff757575),
    super.position,
    required super.size,
    super.anchor = Anchor.center,
  })  : paint = Paint()..color = color,
        _rect = RRect.fromRectAndRadius(
            size!.toRect(), Radius.circular(size.y / 4));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _labelComponent = TextComponent(
      text: label,
      anchor: Anchor.center,
      position: size / 2,
    );
    await add(_labelComponent);

    _itemComponents = items.map((item) {
      return TextComponent(
        text: item,
        anchor: Anchor.center,
        position: size / 2,
      );
    }).toList();
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (kDebugMode) {
      print('Dropdown tapped: $label');
    }
    _isExpanded = !_isExpanded;
    if (_isExpanded) {
      _showItems();
    } else {
      _hideItems();
    }
  }

  void _showItems() {
    for (var i = 0; i < _itemComponents.length; i++) {
      var itemComponent = _itemComponents[i];
      itemComponent.position =
          Vector2(size.x / _itemComponents.length * (i + 0.5), size.y * 1.7);
      add(itemComponent);
    }
  }

  void _hideItems() {
    for (var itemComponent in _itemComponents) {
      remove(itemComponent);
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rect, paint);
  }
}
