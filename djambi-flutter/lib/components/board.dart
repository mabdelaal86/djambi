import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../models/common.dart';
import '../models/member.dart';
import '../models/parliament.dart';
import 'dimensions.dart';
import 'theme.dart';

extension PaintExtension on Paint {
  Paint stroke() => this
    ..style = PaintingStyle.stroke
    ..strokeWidth = Dimensions.stroke * 2;
}

class Board extends PositionComponent {
  // @override
  // bool get debugMode => true;

  late final Parliament parliament;
  late GameTheme theme;

  Board(this.parliament, this.theme, {super.position}) : super(size: Dimensions.boardSize);

  @override
  void render(Canvas canvas) {
    _paintBackground(canvas);
    _markAvailableMoves(canvas);
    _drawLines(canvas);
    _writeIndexes(canvas);
    _drawMembers(canvas);
  }

  void _paintBackground(Canvas canvas) {
    // paint margin background
    canvas.drawRect(size.toRect(), theme.marginPaint);
    // paint grid background
    canvas.drawRect(Dimensions.gridOffset & Dimensions.gridSize, theme.lightCellPaint);
    // paint dark cells background
    for (final cell in Cell.allCells()) {
      if (cell.x.isEven == cell.y.isEven) {
        canvas.drawRect(Dimensions.cellOffset(cell) & Dimensions.cellSize, theme.darkCellPaint);
      }
    }
    // paint maze
    canvas.drawRect(Dimensions.mazeOffset & Dimensions.cellSize, theme.mazePaint);
  }

  void _drawLines(Canvas canvas) {
    // margins
    canvas.drawLine(Offset.zero, Offset(size.x, 0), theme.linePaint);
    canvas.drawLine(Offset.zero, Offset(0, size.y), theme.linePaint);
    // draw 10 vertical/horizontal lines with board height/width
    for (var i = 0; i <= Constants.boardSize; i++) {
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
    for (var i = 0; i < Constants.boardSize; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      writeText(cols[i], Offset(d, 0), Dimensions.marginColCell);
      writeText(rows[i], Offset(0, d), Dimensions.marginRowCell);
    }
  }

  void _drawMembers(Canvas canvas) {
    for (final member in parliament.members) {
      _drawMember(canvas, member);
    }
  }

  void _drawMember(Canvas canvas, Member member) {
    final Offset centerOffset = Dimensions.cellCenterOffset(member.location).toOffset();
    _paintMemberBackground(canvas, member, centerOffset);
    if (member.isAlive) {
      _drawMemberSymbol(canvas, member, centerOffset);
    }
  }

  void _paintMemberBackground(Canvas canvas, Member member, Offset offset) {
    final paint = member.isDead ? theme.deadPaint : theme.getPartyPaint(member.ideology);
    canvas.drawCircle(offset, Dimensions.pieceRadius, paint);
    canvas.drawCircle(offset, Dimensions.pieceRadius, theme.linePaint);
  }

  void _drawMemberSymbol(Canvas canvas, Member member, Offset offset) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(style: theme.pieceSymbolStyle, text: member.role.name[0].toUpperCase());
    textPainter.layout();
    textPainter.paint(canvas, offset + textPainter.size.toOffset() / -2);
  }

  void _markAvailableMoves(Canvas canvas) {
    final member = parliament.currentParty.actor;
    if (member == null || member.manoeuvre.isWaiting) {
      _markSelections(canvas, parliament.currentParty.members.map((m) => m.location));
    }
    if (member != null) {
      final offset = Dimensions.cellOffset(parliament.currentParty.actor!.location);
      canvas.drawRect(offset & Dimensions.cellSize, theme.cellMarkPaint);

      if (member.manoeuvre == Manoeuvre.move1 || member.manoeuvre == Manoeuvre.move2) {
        _markMovements(canvas, member.canMoveTo());
      } else if (member.manoeuvre == Manoeuvre.kill) {
        _markMovements(canvas, member.canKill());
      } else if (member.manoeuvre == Manoeuvre.bury) {
        _markMovements(canvas, member.canBury());
      }
    }
  }

  void _markSelections(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      final offset = Dimensions.cellCenterOffset(cell).toOffset();
      const radius = Dimensions.cellSide / 2 - Dimensions.stroke;
      canvas.drawRect(Rect.fromCircle(center: offset, radius: radius), theme.cellMarkPaint..stroke());
    }
  }

  void _markMovements(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      final offset = Dimensions.cellCenterOffset(cell).toOffset();
      const radius = Dimensions.pieceRadius + Dimensions.stroke;
      canvas.drawCircle(offset, radius, theme.moveMarkPaint..stroke());
    }
  }
}
