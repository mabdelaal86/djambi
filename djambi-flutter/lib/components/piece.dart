import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

class Piece extends PositionComponent with TapCallbacks {
  @override
  bool get debugMode => true;

  late Color color;
  var image = "";

  static final Sprite sprite = Sprite(
      Flame.images.fromCache('test.png'));

  @override
  void render(Canvas canvas) {
    sprite.render(canvas);
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("Piece clicked");
  }
}
