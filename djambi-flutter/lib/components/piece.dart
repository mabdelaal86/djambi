import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

class Piece extends PositionComponent with TapCallbacks {
  @override
  bool get debugMode => true;

  static final Sprite sprite = Sprite(
      Flame.images.fromCache('test.png'));

  @override
  void render(Canvas canvas) {
    sprite.render(canvas);
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("A click");
  }
}
