import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

class Button extends PositionComponent with TapCallbacks {
  final String text;
  final Paint paint;
  final void Function() action;
  final RRect _rect;

  Button({
    required this.action,
    required this.text,
    Color color = const Color(0xff757575),
    super.position,
    required super.size,
    super.anchor = Anchor.center,
  })  : paint = Paint()..color = color,
        _rect = RRect.fromRectAndRadius(
            size!.toRect(),
            Radius.circular(size.y / 4)
        );

  @override
  Future<void> onLoad() async {
    await add(TextComponent(
      text: text,
      anchor: Anchor.center,
      position: size / 2,
    ));
  }

  @override
  void onTapUp(TapUpEvent event) => action();

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rect, paint);
  }
}
