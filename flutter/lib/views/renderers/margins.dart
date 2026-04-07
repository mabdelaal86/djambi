import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../../models.dart';
import '../dimensions.dart';
import '../theme.dart';
import '../utils.dart';

const _fontSize = 30.0;

class MarginsRenderer extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final BoardStyle boardStyle;
  final NotationVisibility notationVisibility;

  final List<TextPainter> _colTextPainters, _rowTextPainters;

  MarginsRenderer(this.boardStyle, this.notationVisibility, {super.position, super.anchor, super.size, super.scale})
    : _colTextPainters = [
        for (var i = 0; i < Constants.sideCellsCount; i++)
          _getTextPainter(Constants.colSymbols[i], boardStyle.marginForeColor, Dimensions.cellSide, Dimensions.margin),
      ],
      _rowTextPainters = [
        for (var i = 0; i < Constants.sideCellsCount; i++)
          _getTextPainter(Constants.rowSymbols[i], boardStyle.marginForeColor, Dimensions.margin, Dimensions.cellSide),
      ];

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), boardStyle.marginBackColor.toPaint());
    if (notationVisibility == .none) return;
    _writeIndexes(canvas, 0);
    if (notationVisibility == .topLeft) return;
    _writeIndexes(canvas, Dimensions.margin + Dimensions.gridSide);
  }

  void _writeIndexes(Canvas canvas, double constOffset) {
    for (var i = 0; i < Constants.sideCellsCount; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      _colTextPainters[i].paint(canvas, Offset(d, constOffset));
      _rowTextPainters[i].paint(canvas, Offset(constOffset, d));
    }
  }

  static TextPainter _getTextPainter(String text, Color color, double width, double height) => TextPainter(
    textDirection: .ltr,
    textAlign: .center,
    text: TextSpan(
      style: TextStyle(
        color: color,
        fontWeight: .bold,
        fontSize: _fontSize,
        height: height / _fontSize,
        leadingDistribution: .even,
      ),
      text: text,
    ),
  )..layout(minWidth: width);
}
