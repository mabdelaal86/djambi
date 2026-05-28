import 'package:flutter/painting.dart';

enum PieceTheme { classic, characters }

enum BoardTheme { grayish }

enum NotationVisibility {
  none,
  topLeft,
  full;

  int get reversedIndex => full.index - index;
}

class BoardStyle {
  // margins
  final Color marginBackColor;
  final Color marginForeColor;
  // background
  final Color lightCellColor;
  final Color darkCellColor;
  final bool drawLines;
  final Color lineColor;
  // maze
  final Color mazeBackColor;
  final Color mazeForeColor;
  // pieces
  final Color pieceForeColor;
  final Color pieceEdgeColor;
  final Color deadColor;
  final Color paralysedColor;
  final Color selectableMarkColor;
  final Color selectedMarkColor;
  final Color actionMarkColor;
  final Color movedMarkColor;
  // parties
  final List<Color> partyColor;

  const BoardStyle({
    required this.marginBackColor,
    required this.marginForeColor,
    required this.lightCellColor,
    required this.darkCellColor,
    required this.drawLines,
    required this.lineColor,
    required this.mazeBackColor,
    required this.mazeForeColor,
    required this.pieceForeColor,
    required this.pieceEdgeColor,
    required this.deadColor,
    required this.paralysedColor,
    required this.selectableMarkColor,
    required this.selectedMarkColor,
    required this.actionMarkColor,
    required this.movedMarkColor,
    required this.partyColor,
  });
}
