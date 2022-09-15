import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../configs/common.dart';
import '../configs/theme.dart';
import 'grid.dart';

class Board extends PositionComponent {
  @override
  bool get debugMode => true;

  static final Vector2 margin = Vector2(500, 500);

  late GameTheme theme;
  late final Grid grid;

  Board(this.theme, {super.position}) : super(size: Constants.gridSize + margin) {
    // create grid
    grid = Grid(position: margin)..addToParent(this);
  }

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
    canvas.drawRect(size.toRect(), paint..color = theme.marginColor);
    // draw grid background
    canvas.drawRect(grid.toRect(), paint..color = theme.cellColor);
  }

  void _drawMaze(Canvas canvas) {
    // draw maze cell
    final mazePaint = Paint()..color = theme.mazeColor;
    final mazePosition = margin + Constants.cellSize * Constants.mazeIndex.toDouble();
    canvas.drawRect(mazePosition.toOffset() & Constants.cellSize.toSize(), mazePaint);
  }

  void _drawLines(Canvas canvas) {
    final linePaint = Paint()..color = theme.lineColor;
    // margins
    canvas.drawLine(Offset.zero, Offset(size.x, 0), linePaint);
    canvas.drawLine(Offset.zero, Offset(0, size.y), linePaint);
    // draw 10 horizontal lines with board width
    for (var r = 0; r <= Constants.boardCells; r++) {
      final y = margin.y + r * Constants.cellSide;
      canvas.drawLine(Offset(0, y), Offset(size.x, y), linePaint);
    }
    // draw 10 vertical lines with board height
    for (var c = 0; c <= Constants.boardCells; c++) {
      final x = margin.x + c * Constants.cellSide;
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), linePaint);
    }
  }

  void _paintIndexes(Canvas canvas) {
    final style = TextStyle(color: theme.lineColor, fontSize: 300);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void paintText(String text, Offset cellOffset, Vector2 cellSize) {
      textPainter.text = TextSpan(style: style, text: text);
      textPainter.layout();
      final cellCenter = (cellSize - textPainter.size.toVector2()) / 2;
      textPainter.paint(canvas, cellOffset + cellCenter.toOffset());
    }

    paintText("#", Offset.zero, margin);

    const cols = "ABCDEFGHI";
    final colCell = Vector2(Constants.cellSide, margin.y);
    for (var c = 0; c < Constants.boardCells; c++) {
      final cellOffset = Offset(margin.x + c * Constants.cellSide, 0);
      paintText(cols[c], cellOffset, colCell);
    }

    const rows = "123456789";
    final rowCell = Vector2(margin.x, Constants.cellSide);
    for (var r = 0; r < Constants.boardCells; r++) {
      final cellOffset = Offset(0, margin.y + r * Constants.cellSide);
      paintText(rows[r], cellOffset, rowCell);
    }
  }
}
