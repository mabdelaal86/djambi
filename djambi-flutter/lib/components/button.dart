import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';

import 'settings.dart';
import 'theme.dart';

class Button extends PositionComponent with TapCallbacks {
  final Color color;
  final String text;
  final Function _tapUpCallback;

  GameTheme get _gameTheme => AppearanceSettings.instance.gameTheme;

  Button(this.color, Vector2 position, Vector2 size, {required Function tapUpCallback, this.text = ""}):
        _tapUpCallback = tapUpCallback,
        super(position: position, size: size);

  @override
  void onTapUp(TapUpEvent event) => _tapUpCallback.call();

  @override
  void render(Canvas canvas) {
    canvas.drawOval(size.toRect(), _gameTheme.marginPaint);
    if (text.isNotEmpty) {
      writeText(canvas);
    }
  }

  void writeText(Canvas canvas) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(style: _gameTheme.marginTextStyle, text: text);
    textPainter.layout();
    final cellCenter = (size - textPainter.size.toVector2()) / 2;
    textPainter.paint(canvas, cellCenter.toOffset());
  }
}
