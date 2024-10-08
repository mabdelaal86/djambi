import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/painting.dart';

import '../../models/cell.dart';
import '../../models/common.dart';
import '../dimensions.dart';
import '../extensions.dart';
import '../theme.dart';

class BackgroundRenderer {
  final BoardTheme boardTheme;
  final PieceTheme pieceTheme;
  late final Svg _mazeImage;

  BackgroundRenderer(this.boardTheme, this.pieceTheme);

  Future<void> onLoad() async {
    _mazeImage = await Utils.loadImage(Role.chief.name, boardTheme.mazeForeColor);
  }

  void render(Canvas canvas) {
    _paintBackground(canvas);
    _drawMaze(canvas);
    if (boardTheme.drawLines) {
      _drawLines(canvas);
    }
    _writeIndexes(canvas);
  }

  void _paintBackground(Canvas canvas) {
    // paint margin background
    canvas.drawRect(Dimensions.boardSize.toRect(), boardTheme.marginPaint);
    // paint cells background
    for (final cell in Cell.allCells()) {
      canvas.drawRect(
        Dimensions.cellOffset(cell) & Dimensions.cellSize,
        cell.isDark ? boardTheme.darkCellPaint : boardTheme.lightCellPaint);
    }
  }

  void _drawMaze(Canvas canvas) {
    canvas.drawRect(Dimensions.mazeOffset & Dimensions.cellSize, boardTheme.mazePaint);
    switch (pieceTheme) {
      case PieceTheme.classic: _drawChiefClassicImage(canvas);
      case PieceTheme.characters: _drawChiefSymbol(canvas);
    }
  }

  void _drawLines(Canvas canvas) {
    // margins
    canvas.drawLine(Offset.zero, Offset(Dimensions.boardSize.x, 0), boardTheme.linePaint);
    canvas.drawLine(Offset.zero, Offset(0, Dimensions.boardSize.y), boardTheme.linePaint);
    // draw 10 vertical/horizontal lines with board height/width
    for (int i = 0; i <= Constants.boardSize; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      canvas.drawLine(Offset(d, 0), Offset(d, Dimensions.boardSize.y), boardTheme.linePaint);
      canvas.drawLine(Offset(0, d), Offset(Dimensions.boardSize.x, d), boardTheme.linePaint);
    }
  }

  void _writeIndexes(Canvas canvas) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void writeText(String text, Offset cellOffset, Vector2 cellSize) {
      textPainter.text = TextSpan(style: boardTheme.marginTextStyle, text: text);
      textPainter.layout();
      final cellCenter = (cellSize - textPainter.size.toVector2()) / 2;
      textPainter.paint(canvas, cellOffset + cellCenter.toOffset());
    }

    for (int i = 0; i < Constants.boardSize; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      writeText(Cell.cols[i], Offset(d, 0), Dimensions.marginColCell);
      writeText(Cell.rows[i], Offset(0, d), Dimensions.marginRowCell);
    }
  }

  void _drawChiefClassicImage(Canvas canvas) {
    final offset = Dimensions.mazeCentralOffset.toOffset();
    final vector = offset.toVector2() - Vector2.all(Dimensions.pieceRadius);
    _mazeImage.renderPosition(canvas, vector, Dimensions.pieceSize);
  }

  void _drawChiefSymbol(Canvas canvas) {
    final offset = Dimensions.mazeCentralOffset.toOffset();
    final style = boardTheme.pieceSymbolStyle.copyWith(color: boardTheme.mazeForeColor);
    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(style: style, text: Role.chief.name[0].toUpperCase());
    textPainter.layout();
    textPainter.paint(canvas, offset + textPainter.size.toOffset() / -2);
  }
}
