import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

import '../configs/common.dart';
import '../configs/theme.dart';

class Piece extends PositionComponent with TapCallbacks {
  @override
  bool get debugMode => true;

  late GameTheme theme;
  String image = "";
  bool isDead = false;
  late Player player;

  static final Sprite sprite = Sprite(
      Flame.images.fromCache('test.png'));

  Piece(this.player, this.theme) : super(size: Vector2.all(Constants.cellSide));

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    _drawBackground(canvas);
    sprite.render(canvas, anchor: Anchor.center);
    canvas.restore();
  }

  void _drawBackground(Canvas canvas) {
    final color = isDead ? theme.deadColor : theme.playerColors[player]!;
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset.zero, Constants.pieceRadius, paint);
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("Piece clicked");
  }
}
