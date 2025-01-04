import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../../models.dart';
import '../dimensions.dart';
import '../theme.dart';

class MarginsRenderer extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final BoardStyle boardStyle;
  final MarginsVisibility marginsVisibility;

  final _textPainter = TextPainter(textDirection: TextDirection.ltr);

  MarginsRenderer(this.boardStyle, this.marginsVisibility,
      {super.position, super.anchor, super.size, super.scale});

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), boardStyle.marginPaint);
    if (marginsVisibility != MarginsVisibility.none) {
      _writeIndexes(canvas, 0);
      if (marginsVisibility == MarginsVisibility.full) {
        _writeIndexes(canvas, Dimensions.margin + Dimensions.gridSide);
      }
    }
  }

  void _writeText(Canvas canvas, String text, Offset cellOffset, Vector2 cellSize) {
    _textPainter.text = TextSpan(style: boardStyle.marginTextStyle, text: text);
    _textPainter.layout();
    final cellCenter = (cellSize - _textPainter.size.toVector2()) / 2;
    _textPainter.paint(canvas, cellOffset + cellCenter.toOffset());
  }

  void _writeIndexes(Canvas canvas, double constOffset) {
    for (var i = 0; i < Constants.sideCellsCount; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      _writeText(canvas, Constants.colSymbols[i], Offset(d, constOffset), Dimensions.marginColCell);
      _writeText(canvas, Constants.rowSymbols[i], Offset(constOffset, d), Dimensions.marginRowCell);
    }
  }
}
