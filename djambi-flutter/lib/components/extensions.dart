import 'dart:ui';

import 'dimensions.dart';

extension PaintExtension on Paint {
  Paint stroke() => this
    ..style = PaintingStyle.stroke
    ..strokeWidth = Dimensions.stroke * 2;
}

extension ColorHex on Color {
  String toHex() => '#${(value & 0xffffff).toRadixString(16).padLeft(6, '0')}';
}
