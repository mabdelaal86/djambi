import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/painting.dart';

import '../../models/cell.dart';
import '../../models/constants.dart' as constants;
import '../../models/enums.dart';
import '../dimensions.dart' as dimensions;
import '../theme.dart';
import '../utils.dart';

class BackgroundRenderer {
  final BoardTheme boardTheme;
  final PieceTheme pieceTheme;
  late final Svg _mazeImage;

  BackgroundRenderer(this.boardTheme, this.pieceTheme);

  Future<void> onLoad() async {
    _mazeImage = await loadImage(Role.chief.name, boardTheme.mazeForeColor);
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
    canvas.drawRect(dimensions.boardSize.toRect(), boardTheme.marginPaint);
    // paint cells background
    for (final cell in Cell.allCells()) {
      canvas.drawRect(
        dimensions.cellOffset(cell) & dimensions.cellSize,
        cell.isDark ? boardTheme.darkCellPaint : boardTheme.lightCellPaint);
    }
  }

  void _drawMaze(Canvas canvas) {
    canvas.drawRect(dimensions.mazeOffset & dimensions.cellSize, boardTheme.mazePaint);
    switch (pieceTheme) {
      case PieceTheme.classic: _drawChiefClassicImage(canvas);
      case PieceTheme.characters: _drawChiefSymbol(canvas);
    }
  }

  void _drawLines(Canvas canvas) {
    // margins
    canvas.drawLine(Offset.zero, Offset(dimensions.boardSize.x, 0), boardTheme.linePaint);
    canvas.drawLine(Offset.zero, Offset(0, dimensions.boardSize.y), boardTheme.linePaint);
    // draw 10 vertical/horizontal lines with board height/width
    for (var i = 0; i <= constants.boardSize; i++) {
      final d = dimensions.margin + i * dimensions.cellSide;
      canvas.drawLine(Offset(d, 0), Offset(d, dimensions.boardSize.y), boardTheme.linePaint);
      canvas.drawLine(Offset(0, d), Offset(dimensions.boardSize.x, d), boardTheme.linePaint);
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

    for (var i = 0; i < constants.boardSize; i++) {
      final d = dimensions.margin + i * dimensions.cellSide;
      writeText(constants.colSymbols[i], Offset(d, 0), dimensions.marginColCell);
      writeText(constants.rowSymbols[i], Offset(0, d), dimensions.marginRowCell);
    }
  }

  void _drawChiefClassicImage(Canvas canvas) {
    final offset = dimensions.mazeCentralOffset.toOffset();
    final vector = offset.toVector2() - Vector2.all(dimensions.pieceRadius);
    _mazeImage.renderPosition(canvas, vector, dimensions.pieceSize);
  }

  void _drawChiefSymbol(Canvas canvas) {
    final offset = dimensions.mazeCentralOffset.toOffset();
    final style = boardTheme.pieceSymbolStyle.copyWith(color: boardTheme.mazeForeColor);
    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(style: style, text: Role.chief.name[0].toUpperCase());
    textPainter.layout();
    textPainter.paint(canvas, offset + textPainter.size.toOffset() / -2);
  }
}
