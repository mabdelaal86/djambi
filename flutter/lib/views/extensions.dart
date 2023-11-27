import 'package:flame/flame.dart';
import 'package:flame_svg/flame_svg.dart' show Svg;
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgStringLoader;
import 'package:vector_graphics/vector_graphics.dart';

import 'dimensions.dart';

extension PaintExtension on Paint {
  Paint stroke() => this
    ..style = PaintingStyle.stroke
    ..strokeWidth = Dimensions.markStroke * 2;
}

extension ColorExtension on Color {
  String get hex => '#${(value & 0xffffff).toRadixString(16).padLeft(6, '0')}';
  Paint paint() => Paint()..color = this;
}

class Utils {
  static Future<Svg> loadImage(String image, Color color,
      {String style = "classic"}) async {
    String fileName = "$style/$image.svg";
    final fileContent = await Flame.assets.readFile(fileName);
    final opacity = color.alpha.toDouble() / 0xff;
    final svgString = fileContent.replaceFirst(
        "fill:#000000;fill-opacity:1",
        "fill:${color.hex};fill-opacity:$opacity");
    final pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);
    return Svg(pictureInfo);
  }
}
