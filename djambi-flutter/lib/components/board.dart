import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../models/common.dart';
import '../models/piece.dart';
import '../models/tourney.dart';
import 'dimensions.dart';
import 'theme.dart';

class Board extends PositionComponent {
  // @override
  // bool get debugMode => true;

  late final Tourney tourney;
  late GameTheme theme;

  Board(this.tourney, this.theme, {super.position}) : super(size: Dimensions.boardSize);

  @override
  void render(Canvas canvas) {
    _paintBackground(canvas);
    _paintMaze(canvas);
    _drawLines(canvas);
    _writeIndexes(canvas);
    _drawPieces(canvas);
  }

  void _paintBackground(Canvas canvas) {
    var paint = Paint();
    // paint margin background
    canvas.drawRect(size.toRect(), paint..color = theme.marginColor);
    // paint grid background
    canvas.drawRect(Dimensions.gridOffset & Dimensions.gridSize, paint..color = theme.cellColor);
  }

  void _paintMaze(Canvas canvas) {
    // paint maze cell
    final mazePaint = Paint()..color = theme.mazeColor;
    canvas.drawRect(Dimensions.mazeOffset & Dimensions.cellSize, mazePaint);
  }

  void _drawLines(Canvas canvas) {
    final linePaint = Paint()..color = theme.lineColor;
    // margins
    canvas.drawLine(Offset.zero, Offset(size.x, 0), linePaint);
    canvas.drawLine(Offset.zero, Offset(0, size.y), linePaint);
    // draw 10 vertical/horizontal lines with board height/width
    for (var i = 0; i <= Configs.boardCells; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      canvas.drawLine(Offset(d, 0), Offset(d, size.y), linePaint);
      canvas.drawLine(Offset(0, d), Offset(size.x, d), linePaint);
    }
  }

  void _writeIndexes(Canvas canvas) {
    final style = TextStyle(color: theme.lineColor, fontSize: 300);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void writeText(String text, Offset cellOffset, Vector2 cellSize) {
      textPainter.text = TextSpan(style: style, text: text);
      textPainter.layout();
      final cellCenter = (cellSize - textPainter.size.toVector2()) / 2;
      textPainter.paint(canvas, cellOffset + cellCenter.toOffset());
    }

    writeText("#", Offset.zero, Dimensions.gridOffset);

    const cols = "ABCDEFGHI", rows = "123456789";
    for (var i = 0; i < Configs.boardCells; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      writeText(cols[i], Offset(d, 0), Dimensions.marginColCell);
      writeText(rows[i], Offset(0, d), Dimensions.marginRowCell);
    }
  }

  void _drawPieces(Canvas canvas) {
    for (final piece in tourney.allPieces()) {
      _drawPiece(canvas, piece);
    }
  }

  void _drawPiece(Canvas canvas, Piece piece) {
    final Offset centerOffset = Dimensions.cellCenterOffset(piece.cell).toOffset();
    _paintPieceBackground(canvas, piece, centerOffset);
    if (!piece.isDead) {
      _drawPieceSymbol(canvas, piece, centerOffset);
    }
  }

  void _paintPieceBackground(Canvas canvas, Piece piece, Offset offset) {
    final color = piece.isDead ? theme.deadColor : theme.playerColors[piece.playerId]!;
    final paint = Paint()..color = color;
    canvas.drawCircle(offset, Dimensions.pieceRadius, paint);
  }

  void _drawPieceSymbol(Canvas canvas, Piece piece, Offset offset) {
    final style = TextStyle(color: theme.lineColor, fontSize: 500, fontWeight: FontWeight.bold);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(style: style, text: piece.type.name[0].toUpperCase());
    textPainter.layout();
    textPainter.paint(canvas, offset + textPainter.size.toOffset() / -2);
  }
}
