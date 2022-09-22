import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../models/member.dart';
import '../models/parliament.dart';
import 'dimensions.dart';
import 'theme.dart';

class Board extends PositionComponent {
  // @override
  // bool get debugMode => true;

  late final Parliament tourney;
  late GameTheme theme;

  Board(this.tourney, this.theme, {super.position}) : super(size: Dimensions.boardSize);

  @override
  void render(Canvas canvas) {
    _paintBackground(canvas);
    _paintMaze(canvas);
    _markAvailableMoves(canvas);
    _drawLines(canvas);
    _writeIndexes(canvas);
    _drawPieces(canvas);
  }

  void _paintBackground(Canvas canvas) {
    // paint margin background
    canvas.drawRect(size.toRect(), theme.marginPaint);
    // paint grid background
    canvas.drawRect(Dimensions.gridOffset & Dimensions.gridSize, theme.cellBgPaint);
  }

  void _paintMaze(Canvas canvas) {
    canvas.drawRect(Dimensions.mazeOffset & Dimensions.cellSize, theme.mazePaint);
  }

  void _drawLines(Canvas canvas) {
    // margins
    canvas.drawLine(Offset.zero, Offset(size.x, 0), theme.linePaint);
    canvas.drawLine(Offset.zero, Offset(0, size.y), theme.linePaint);
    // draw 10 vertical/horizontal lines with board height/width
    for (var i = 0; i <= Parliament.size; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      canvas.drawLine(Offset(d, 0), Offset(d, size.y), theme.linePaint);
      canvas.drawLine(Offset(0, d), Offset(size.x, d), theme.linePaint);
    }
  }

  void _writeIndexes(Canvas canvas) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void writeText(String text, Offset cellOffset, Vector2 cellSize) {
      textPainter.text = TextSpan(style: theme.marginTextStyle, text: text);
      textPainter.layout();
      final cellCenter = (cellSize - textPainter.size.toVector2()) / 2;
      textPainter.paint(canvas, cellOffset + cellCenter.toOffset());
    }

    writeText("#", Offset.zero, Dimensions.gridOffset);

    const cols = "ABCDEFGHI", rows = "123456789";
    for (var i = 0; i < Parliament.size; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      writeText(cols[i], Offset(d, 0), Dimensions.marginColCell);
      writeText(rows[i], Offset(0, d), Dimensions.marginRowCell);
    }
  }

  void _drawPieces(Canvas canvas) {
    for (final piece in tourney.allMembers()) {
      _drawPiece(canvas, piece);
    }
  }

  void _drawPiece(Canvas canvas, Member piece) {
    final Offset centerOffset = Dimensions.cellCenterOffset(piece.cell).toOffset();
    _paintPieceBackground(canvas, piece, centerOffset);
    if (!piece.isDead) {
      _drawPieceSymbol(canvas, piece, centerOffset);
    }
  }

  void _paintPieceBackground(Canvas canvas, Member piece, Offset offset) {
    final paint = piece.isDead ? theme.deadPaint : theme.getPlayerPaint(piece.ideology);
    canvas.drawCircle(offset, Dimensions.pieceRadius, paint);
  }

  void _drawPieceSymbol(Canvas canvas, Member piece, Offset offset) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(style: theme.pieceSymbolStyle, text: piece.role.name[0].toUpperCase());
    textPainter.layout();
    textPainter.paint(canvas, offset + textPainter.size.toOffset() / -2);
  }

  void _markAvailableMoves(Canvas canvas) {
    for (final cell in tourney.selectableCells()) {
      canvas.drawRect(Dimensions.cellOffset(cell) & Dimensions.cellSize, theme.cellMarkPaint);
    }
  }
}
