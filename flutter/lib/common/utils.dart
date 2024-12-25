import 'dart:ui';

import 'package:flame/components.dart';

extension AnchorExtension on Anchor {
  Vector2 ofSize(Vector2 size) => Vector2(x * size.x, y * size.y);
}

extension ColorExtension on Color {
  String toHex() => '#${_hex(r)}${_hex(g)}${_hex(b)}';
  Paint toPaint() => Paint()..color = this;
}

String _hex(double v) => (v * 255).round().toRadixString(16).padLeft(2, '0');
