import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame_svg/flame_svg.dart' show Svg;
import 'package:flutter_svg/flutter_svg.dart' show SvgStringLoader;
import 'package:vector_graphics/vector_graphics.dart';

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
  static Future<Svg> loadImage(String image, Color color,
      {String style = "classic"}) async {
    String fileName = "$style/$image.svg";
    final fileContent = await Flame.assets.readFile(fileName);
    final opacity = color.alpha.toDouble() / 0xff;
    final svgString = fileContent.replaceFirst(
        "fill:#000000;fill-opacity:1",
        "fill:${color.toHex()};fill-opacity:$opacity");
    final pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);
    return Svg(pictureInfo);
  }
}
