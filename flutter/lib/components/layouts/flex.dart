import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class FlexComponent extends PositionComponent {
  final Axis axis;
  final double spacing;
  late final List<PositionComponent> _elements;

  FlexComponent({
    super.position,
    super.anchor,
    super.scale,
    required List<PositionComponent> children,
    this.axis = Axis.vertical,
    this.spacing = 0,
  }) : super(size: _calcSize(spacing, axis, children)) {
    _elements = children;
    assert(spacing >= 0, "Spacing between elements can't be less than zero");
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll(_elements);
  }

  @override
  void onParentResize(Vector2 maxSize) {
    _updateChildrenPositions();
  }

  void _updateChildrenPositions() {
    double start = 0;
    if (axis == Axis.vertical) {
      for (final elem in _elements) {
        elem.position = Vector2(0, start);
        start += elem.size.y + spacing;
      }
    } else {
      for (final elem in _elements) {
        elem.position = Vector2(start, 0);
        start += elem.size.x + spacing;
      }
    }
  }
}

Vector2 _calcSize(
    double spacing,
    Axis axis,
    List<PositionComponent> elements,
) {
  final spaces = spacing * (elements.length - 1);
  var res = axis == Axis.vertical ? Vector2(0, spaces) : Vector2(spaces, 0);
  for (final elem in elements) {
    assert(!elem.size.isZero(), "Element has no size to be arranged");
    assert(elem.position.isZero(), "Element position shouldn't be set");
    if (axis == Axis.vertical) {
      res = Vector2(max(res.x, elem.size.x), res.y + elem.size.y);
    } else {
      res = Vector2(res.x + elem.size.x, max(res.y, elem.size.y));
    }
  }
  return res;
}
