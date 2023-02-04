import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter_svg/svg.dart' show svg;

import 'dimensions.dart';

extension PaintExtension on Paint {
  Paint stroke() => this
    ..style = PaintingStyle.stroke
    ..strokeWidth = Dimensions.stroke * 2;
}

extension ColorHex on Color {
  String toHex() => '#${(value & 0xffffff).toRadixString(16).padLeft(6, '0')}';
}

class Utils {
  static Future<Svg> loadImage(String image, Color color, {String style = "classic"}) async {
    String fileName = "$style/$image.svg";
    final fileContent = await Flame.assets.readFile(fileName);
    final opacity = color.alpha.toDouble() / 0xff;
    final svgString = fileContent.replaceFirst(
        "fill:#000000;fill-opacity:1", "fill:${color.toHex()};fill-opacity:$opacity");
    return Svg(await svg.fromSvgString(svgString, svgString));
  }
}
