import 'package:flame/components.dart';

class MultiAlignComponent extends PositionComponent {
  final Map<Anchor, PositionComponent> alignedChildren;

  MultiAlignComponent({
    super.position,
    super.anchor,
    super.size,
    super.scale,
    required this.alignedChildren,
  }) {
    addAll(alignedChildren.values);
    _updateChildrenAnchors();
  }

  void _updateChildrenAnchors() {
    for (final item in alignedChildren.entries) {
      item.value.anchor = item.key;
    }
  }

  @override
  void onParentResize(Vector2 maxSize) {
    _updateChildrenPositions();
  }

  void _updateChildrenPositions() {
    for (final item in alignedChildren.entries) {
      item.value.position = Vector2(size.x * item.key.x, size.y * item.key.y);
    }
  }
}
