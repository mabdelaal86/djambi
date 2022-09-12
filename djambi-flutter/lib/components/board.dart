import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../configs/common.dart';
import '../configs/theme.dart';

class Board extends PositionComponent with TapCallbacks {
  @override
  bool get debugMode => true;

  static const Offset margin = Offset(500, 500);
  static const Size cellSize = Size.square(Constants.cellSide);
  static final Size boardSize = cellSize * Constants.boardCells.toDouble();
  static final Size allSize = boardSize + margin;

  late GameTheme theme;

  Board(this.theme) : super(size: allSize.toVector2());

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
    canvas.drawRect(Offset.zero & allSize, paint..color = theme.marginColor);
    // draw board background
    canvas.drawRect(margin & boardSize, paint..color = theme.cellColor);
  }

  void _drawMaze(Canvas canvas) {
    // draw maze cell
    final mazePaint = Paint()..color = theme.mazeColor;
    final mazeOffset = cellSize.toOffset() * Constants.mazeIndex.toDouble();
    canvas.drawRect(margin + mazeOffset & cellSize, mazePaint);
  }

  void _drawLines(Canvas canvas) {
    final linePaint = Paint()..color = theme.lineColor;
    // margins
    canvas.drawLine(Offset.zero, Offset(allSize.width, 0), linePaint);
    canvas.drawLine(Offset.zero, Offset(0, allSize.height), linePaint);
    // draw 10 horizontal lines with board width
    for (var r = 0; r <= Constants.boardCells; r++) {
      final y = margin.dy + r * Constants.cellSide;
      canvas.drawLine(Offset(0, y), Offset(allSize.width, y), linePaint);
    }
    // draw 10 vertical lines with board height
    for (var c = 0; c <= Constants.boardCells; c++) {
      final x = margin.dx + c * Constants.cellSide;
      canvas.drawLine(Offset(x, 0), Offset(x, allSize.height), linePaint);
    }
  }

  void _paintIndexes(Canvas canvas) {
    final style = TextStyle(color: theme.lineColor, fontSize: 300);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(style: style, text: "#");
    textPainter.layout();
    textPainter.paint(canvas, (margin - textPainter.size.toOffset()) / 2);

    const cols = "ABCDEFGHI";
    final colCell = Offset(Constants.cellSide, margin.dy);
    for (var c = 0; c < Constants.boardCells; c++) {
      final cellOffset = Offset(margin.dx + c * Constants.cellSide, 0);
      textPainter.text = TextSpan(style: style, text: cols[c]);
      textPainter.layout();
      final cellCenter = (colCell - textPainter.size.toOffset()) / 2;
      textPainter.paint(canvas, cellOffset + cellCenter);
    }

    const rows = "123456789";
    final rowCell = Offset(margin.dx, Constants.cellSide);
    for (var r = 0; r < Constants.boardCells; r++) {
      final cellOffset = Offset(0, margin.dy + r * Constants.cellSide);
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
