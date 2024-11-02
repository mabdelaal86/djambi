import 'dart:ui';

import 'package:flame/components.dart';

extension AnchorExtension on Anchor {
  Vector2 ofSize(Vector2 size) => Vector2(x * size.x, y * size.y);
}

extension ColorExtension on Color {
  String get hex => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  Paint toPaint() => Paint()..color = this;
}
