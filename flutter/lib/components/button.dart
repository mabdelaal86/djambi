import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

class Button extends PositionComponent with TapCallbacks {
  final IconData? icon;
  final String text;
  final Paint bgPaint;
  final TextStyle textStyle;
  final void Function() action;

  Button({
      required super.position,
      required super.size,
      required this.bgPaint,
      required this.textStyle,
      this.icon,
      this.text = "",
      required this.action,
  });

  @override
  void onTapUp(TapUpEvent event) => action();

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(150));
    canvas.drawRRect(rect, bgPaint);
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
    return icon == null
        ? TextSpan(text: text, style: textStyle)
        : TextSpan(
            text: String.fromCharCode(icon!.codePoint),
            style: textStyle.copyWith(fontFamily: icon!.fontFamily));
  }
}
