import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Button extends PositionComponent with TapCallbacks {
  final IconData? icon;
  final String text;
  final Paint bgPaint;
  final TextStyle textStyle;
  final Function _tapUpCallback;

  Button(Vector2 position, Vector2 size, this.bgPaint, this.textStyle,
      {required Function tapUpCallback, this.icon, this.text = ""}):
        _tapUpCallback = tapUpCallback,
        super(position: position, size: size);

  @override
  void onTapUp(TapUpEvent event) => _tapUpCallback.call();

  @override
  void render(Canvas canvas) {
    canvas.drawOval(size.toRect(), bgPaint);
    _draw(canvas);
  }

  void _draw(Canvas canvas) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = _textSpan();
    textPainter.layout();
    final cellCenter = (size - textPainter.size.toVector2()) / 2;
    textPainter.paint(canvas, cellCenter.toOffset());
  }

  TextSpan _textSpan() {
    return icon == null ?
      TextSpan(text: text, style: textStyle) :
      TextSpan(
        text: String.fromCharCode(icon!.codePoint),
        style: textStyle.copyWith(fontFamily: icon!.fontFamily),
      );
  }
}
