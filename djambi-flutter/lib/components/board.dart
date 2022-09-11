import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

class Board extends PositionComponent with TapCallbacks {
  static const sideCount = 9;
  static const mazeIndex = 4; // int(9 / 2)
  static const double cellSize = 1000;
  static const double sideSize = cellSize * sideCount;

  static final bgPaint = Paint()..color = Colors.white70;
  static final mazePaint = Paint()..color = Colors.black;
  static final linePaint = Paint()..color = Colors.black;

  @override
  bool get debugMode => true;

  @override
  void render(Canvas canvas) {
    drawBackground(canvas);
    drawLines(canvas);
  }

  void drawBackground(Canvas canvas) {
    // draw white background
    canvas.drawRect(
        Rect.fromLTWH(position.x, position.y, sideSize, sideSize), bgPaint);
    canvas.drawRect(
        Rect.fromLTWH(
            position.x + mazeIndex * cellSize,
            position.y + mazeIndex * cellSize,
            cellSize, cellSize), mazePaint);
  }

  void drawLines(Canvas canvas) {
    final baseOffset = Offset(position.x, position.y);
    // draw horizontal lines with board width
    for (var r = 0; r < sideCount; r++) {
      canvas.drawLine(
          baseOffset + Offset(0, r * cellSize),
          baseOffset + Offset(sideSize, r * cellSize),
          linePaint);
    }
    // draw vertical lines with board height
    for (var c = 0; c < sideCount; c++) {
      canvas.drawLine(
          baseOffset + Offset(c * cellSize, 0),
          baseOffset + Offset(c * cellSize, sideSize),
          linePaint);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("A click");
  }
}
