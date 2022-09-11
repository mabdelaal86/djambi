import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Board extends PositionComponent with TapCallbacks {
  @override
  bool get debugMode => true;

  static const int sideCount = 9;
  static const int mazeIndex = sideCount ~/ 2; // 4
  static const Offset margin = Offset(500, 500);
  static const Size cellSize = Size.square(1000);
  static final Size boardSize = cellSize * sideCount.toDouble();
  static final Size sideSize = boardSize + margin;

  Color cellColor = Colors.grey;
  Color mazeColor = Colors.black;
  Color lineColor = Colors.black;
  Color marginColor = Colors.white;

  @override
  void render(Canvas canvas) {
    _drawBackground(canvas);
    _drawMaze(canvas);
    _drawLines(canvas);
    _paintIndexes(canvas);
  }

  void _drawBackground(Canvas canvas) {
    var paint = Paint();
    // draw margin background
    canvas.drawRect(Offset.zero & sideSize, paint..color = marginColor);
    // draw board background
    canvas.drawRect(margin & boardSize, paint..color = cellColor);
  }

  void _drawMaze(Canvas canvas) {
    // draw maze cell
    final mazePaint = Paint()..color = mazeColor;
    final mazeOffset = margin + cellSize.toOffset() * mazeIndex.toDouble();
    canvas.drawRect(mazeOffset & cellSize, mazePaint);
  }

  void _drawLines(Canvas canvas) {
    final linePaint = Paint()..color = lineColor;
    // margins
    canvas.drawLine(Offset.zero, Offset(sideSize.width, 0), linePaint);
    canvas.drawLine(Offset.zero, Offset(0, sideSize.height), linePaint);
    // draw 10 horizontal lines with board width
    for (var r = 0; r <= sideCount; r++) {
      final y = margin.dy + r * cellSize.height;
      canvas.drawLine(Offset(0, y), Offset(sideSize.width, y), linePaint);
    }
    // draw 10 vertical lines with board height
    for (var c = 0; c <= sideCount; c++) {
      final x = margin.dx + c * cellSize.width;
      canvas.drawLine(Offset(x, 0), Offset(x, sideSize.height), linePaint);
    }
  }

  void _paintIndexes(Canvas canvas) {
    final style = TextStyle(color: lineColor, fontSize: 300);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(style: style, text: "#");
    textPainter.layout();
    textPainter.paint(canvas, (margin - textPainter.size.toOffset()) / 2);

    const cols = "ABCDEFGHI";
    final colCell = Offset(cellSize.width, margin.dy);
    for (var c = 0; c < sideCount; c++) {
      final cellOffset = Offset(margin.dx + c * cellSize.width, 0);
      textPainter.text = TextSpan(style: style, text: cols[c]);
      textPainter.layout();
      final cellCenter = (colCell - textPainter.size.toOffset()) / 2;
      textPainter.paint(canvas, cellOffset + cellCenter);
    }

    const rows = "123456789";
    final rowCell = Offset(margin.dx, cellSize.height);
    for (var r = 0; r < sideCount; r++) {
      final cellOffset = Offset(0, margin.dy + r * cellSize.height);
      textPainter.text = TextSpan(style: style, text: rows[r]);
      textPainter.layout();
      final cellCenter = (rowCell - textPainter.size.toOffset()) / 2;
      textPainter.paint(canvas, cellOffset + cellCenter);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("Board clicked");
  }
}
