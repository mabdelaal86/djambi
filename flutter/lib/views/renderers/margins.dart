import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../../models/constants.dart' as constants;
import '../dimensions.dart' as dimensions;
import '../theme.dart';
import '../utils.dart';

class MarginsRenderer extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final BoardTheme boardTheme;
  final MarginsVisibility showMargins;

  final _textPainter = TextPainter(textDirection: TextDirection.ltr);

  MarginsRenderer(this.boardTheme, this.showMargins,
      {super.position, super.anchor, super.scale})
      : super(size: calcBoardSize(showMargins));

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), boardTheme.marginPaint);
    if (showMargins != MarginsVisibility.none) {
      _writeIndexes(canvas, 0);
      if (showMargins == MarginsVisibility.full) {
        _writeIndexes(canvas, dimensions.margin + dimensions.gridSide);
      }
    }
  }

  void _writeText(Canvas canvas, String text, Offset cellOffset, Vector2 cellSize) {
    _textPainter.text = TextSpan(style: boardTheme.marginTextStyle, text: text);
    _textPainter.layout();
    final cellCenter = (cellSize - _textPainter.size.toVector2()) / 2;
    _textPainter.paint(canvas, cellOffset + cellCenter.toOffset());
  }

  void _writeIndexes(Canvas canvas, double constOffset) {
    for (var i = 0; i < constants.sideCellsCount; i++) {
      final d = dimensions.margin + i * dimensions.cellSide;
      _writeText(canvas, constants.colSymbols[i], Offset(d, constOffset), dimensions.marginColCell);
      _writeText(canvas, constants.rowSymbols[i], Offset(constOffset, d), dimensions.marginRowCell);
    }
  }
}
