import 'dart:ui';

import 'package:flame/components.dart';

extension AnchorExtension on Anchor {
  Vector2 ofSize(Vector2 size) => Vector2(x * size.x, y * size.y);
}

extension ColorExtension on Color {
  Paint toPaint() => Paint()..color = this;
}
