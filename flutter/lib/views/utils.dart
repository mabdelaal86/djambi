import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';
import 'package:flame_svg/flame_svg.dart' show Svg;

import 'dimensions.dart' as dimensions;

extension PaintExtension on Paint {
  Paint stroke() => this
    ..style = PaintingStyle.stroke
    ..strokeWidth = dimensions.markStroke * 2;
}

extension ColorExtension on Color {
  String get hex => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  Paint paint() => Paint()..color = this;
}

Future<Svg> loadImage(String image, Color color,
    {String style = "classic"}) async {
  final fileContent = await Flame.assets.readFile("$style/$image.svg");
  final opacity = color.alpha.toDouble() / 0xFF;
  final svgString = fileContent.replaceFirst(
      "fill:#000000;fill-opacity:1",
      "fill:${color.hex};fill-opacity:$opacity");
  return Svg.loadFromString(svgString);
}
