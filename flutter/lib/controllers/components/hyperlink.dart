import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';

import '../../common/utils.dart';
import '../configs.dart';

class Hyperlink extends TextBoxComponent with TapCallbacks {
  final String url;

  Hyperlink({
    required this.url,
    required super.text,
    super.anchor,
    super.angle,
    super.position,
    super.scale,
    super.size,
    double fontSize = Configs.defaultFontSize,
    Color color = const Color(0xFF00FFE1),
    String? fontFamily,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? decoration,
  }) {
    super.textRenderer = TextPaint(
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }

  @override
  Future<void> onTapUp(TapUpEvent event) async {
    await openUrl(url);
  }
}
