import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';

import '../../common/utils.dart';
import '../components.dart';

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
    TextRenderer? textRenderer,
  }) {
    super.textRenderer = textRenderer ?? getTextRenderer(
      color: const Color(0xFF00FFE1),
      decoration: TextDecoration.underline,
    );
  }

  @override
  Future<void> onTapUp(TapUpEvent event) async {
    await openUrl(url);
  }
}
