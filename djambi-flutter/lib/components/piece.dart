import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class Piece extends PositionComponent with TapCallbacks {
  @override
  bool get debugMode => true;

  static const Color deadColor = Colors.black;
  static const double radius = 400;

  late Color color;
  String image = "";
  bool isDead = false;

  static final Sprite sprite = Sprite(
      Flame.images.fromCache('test.png'));

  @override
  void render(Canvas canvas) {
    canvas.translate(size.x / 2, size.y / 2);
    _drawBackground(canvas);
    sprite.render(canvas, anchor: Anchor.center);
  }

  void _drawBackground(Canvas canvas) {
    final paint = Paint()..color = isDead ? deadColor : color;
    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("Piece clicked");
  }
}
