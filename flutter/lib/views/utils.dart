import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_svg/flame_svg.dart' show Svg;
import 'package:flutter/painting.dart';

import '../common/utils.dart';
import 'dimensions.dart' as dimensions;
import 'theme.dart';

extension PaintExtension on Paint {
  Paint stroke() => this
    ..style = PaintingStyle.stroke
    ..strokeWidth = dimensions.markStroke * 2;
}

Future<Svg> loadImage(String image, Color color,
    {String style = "classic"}) async {
  final fileContent = await Flame.assets.readFile("$style/$image.svg");
  final svgString = fileContent.replaceFirst(
      "fill:#000000;fill-opacity:1",
      "fill:${color.toHex()};fill-opacity:${color.a}");
  return Svg.loadFromString(svgString);
}

Vector2 calcBoardSize(MarginsVisibility showMargins) => switch(showMargins) {
  MarginsVisibility.none => dimensions.gridSize,
  MarginsVisibility.half => dimensions.gridSize + dimensions.marginSize,
  MarginsVisibility.full => dimensions.gridSize + dimensions.marginSize * 2,
};
