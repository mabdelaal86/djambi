import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../configs/common.dart';
import '../configs/theme.dart';

abstract class Piece extends PositionComponent with TapCallbacks {
  @override
  bool get debugMode => true;

  late GameTheme theme;
  late Player player;
  late String symbol;

  bool _isDead = false;
  bool get isDead => _isDead;
  void die() { _isDead = true; }

  Piece(this.player, this.theme, {required this.symbol}) :
        super(size: Vector2.all(Constants.cellSide));

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    _drawBackground(canvas);
    if (!isDead) {
      drawIcon(canvas);
    }
    canvas.restore();
  }

  void _drawBackground(Canvas canvas) {
    final color = isDead ? theme.deadColor : theme.playerColors[player]!;
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset.zero, Constants.pieceRadius, paint);
  }

  void drawIcon(Canvas canvas) {
    final style = TextStyle(
        color: theme.lineColor, fontSize: 500, fontWeight: FontWeight.bold);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(style: style, text: symbol);
    textPainter.layout();
    textPainter.paint(canvas, textPainter.size.toOffset() / -2);
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("Piece clicked");
  }
}
