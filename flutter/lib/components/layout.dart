import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

class MultiAlignComponent extends PositionComponent {
  final Map<Anchor, PositionComponent> alignedChildren;
  final EdgeInsets padding;

  late final PositionComponent _child;

  MultiAlignComponent({
    super.position,
    super.anchor,
    super.size,
    super.scale,
    required this.alignedChildren,
    this.padding = EdgeInsets.zero,
  }) {
    _updateChildrenAnchors();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(_child = PositionComponent(
      size: size - Vector2(padding.horizontal, padding.vertical),
      children: alignedChildren.values,
    ));
  }

  void _updateChildrenAnchors() {
    for (final MapEntry(:key, :value) in alignedChildren.entries) {
      value.anchor = key;
    }
  }

  @override
  void onParentResize(Vector2 maxSize) {
    _updateChildrenPositions();
  }

  void _updateChildrenPositions() {
    _child.position = padding.topLeft.toVector2();
    for (final MapEntry(:key, :value) in alignedChildren.entries) {
      value.position = Vector2(_child.size.x * key.x, _child.size.y * key.y);
    }
  }
}
