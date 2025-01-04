import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/painting.dart';

import '../../models.dart';
import '../dimensions.dart';
import '../theme.dart';
import '../utils.dart';

class BackgroundRenderer extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final BoardStyle boardStyle;
  final PieceTheme pieceTheme;
  late final Svg _mazeImage;

  BackgroundRenderer(this.boardStyle, this.pieceTheme,
      {super.position, super.anchor, super.scale})
      : super(size: Dimensions.gridSize);

  @override
  Future<void> onLoad() async {
    _mazeImage = await loadImage(Role.chief.name, boardStyle.mazeForeColor);
  }

  @override
  void render(Canvas canvas) {
    _paintBackground(canvas);
    _drawMaze(canvas);
    if (boardStyle.drawLines) {
      _drawLines(canvas);
    }
  }

  void _paintBackground(Canvas canvas) {
    for (final cell in Cell.allCells()) {
      canvas.drawRect(
          cellOffset(cell) & Dimensions.cellSize,
          cell.isDark ? boardStyle.darkCellPaint : boardStyle.lightCellPaint);
    }
  }

  void _drawMaze(Canvas canvas) {
    canvas.drawRect(Dimensions.mazeOffset & Dimensions.cellSize, boardStyle.mazePaint);
    switch (pieceTheme) {
      case PieceTheme.classic: _drawChiefClassicImage(canvas);
      case PieceTheme.characters: _drawChiefSymbol(canvas);
    }
  }

  void _drawLines(Canvas canvas) {
    // draw 10 vertical/horizontal lines with board height/width
    for (var i = 0; i <= Constants.sideCellsCount; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      canvas.drawLine(Offset(d, 0), Offset(d, size.y), boardStyle.linePaint);
      canvas.drawLine(Offset(0, d), Offset(size.x, d), boardStyle.linePaint);
    }
  }

  void _drawChiefClassicImage(Canvas canvas) {
    final offset = Dimensions.mazeCentralOffset.toOffset();
    final vector = offset.toVector2() - Vector2.all(Dimensions.pieceRadius);
    _mazeImage.renderPosition(canvas, vector, Dimensions.pieceSize);
  }

  void _drawChiefSymbol(Canvas canvas) {
    final offset = Dimensions.mazeCentralOffset.toOffset();
    final style = boardStyle.pieceSymbolStyle.copyWith(color: boardStyle.mazeForeColor);
    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(style: style, text: Role.chief.name[0].toUpperCase());
    textPainter.layout();
    textPainter.paint(canvas, offset + textPainter.size.toOffset() / -2);
  }
}
