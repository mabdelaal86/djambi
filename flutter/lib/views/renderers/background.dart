import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/painting.dart';

import '../../models/cell.dart';
import '../../models/constants.dart' as constants;
import '../../models/enums.dart';
import '../dimensions.dart' as dimensions;
import '../theme.dart';
import '../utils.dart';

class BackgroundRenderer extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final BoardTheme boardTheme;
  final PieceTheme pieceTheme;
  late final Svg _mazeImage;

  BackgroundRenderer(this.boardTheme, this.pieceTheme,
      {super.position, super.anchor, super.scale})
      : super(size: dimensions.gridSize);

  @override
  Future<void> onLoad() async {
    _mazeImage = await loadImage(Role.chief.name, boardTheme.mazeForeColor);
  }

  @override
  void render(Canvas canvas) {
    _paintBackground(canvas);
    _drawMaze(canvas);
    if (boardTheme.drawLines) {
      _drawLines(canvas);
    }
  }

  void _paintBackground(Canvas canvas) {
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
    // draw 10 vertical/horizontal lines with board height/width
    for (var i = 0; i <= constants.sideCellsCount; i++) {
      final d = dimensions.margin + i * dimensions.cellSide;
      canvas.drawLine(Offset(d, 0), Offset(d, size.y), boardTheme.linePaint);
      canvas.drawLine(Offset(0, d), Offset(size.x, d), boardTheme.linePaint);
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
