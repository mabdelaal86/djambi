import 'package:flutter/painting.dart';

import 'theme.dart';

BoardStyle getBoardStyle(BoardTheme theme) => switch (theme) {
  .grayish => _getGrayishBoardStyle(),
};

BoardStyle _getGrayishBoardStyle() => const BoardStyle(
  marginBackColor: Color(0xFF757575),
  marginForeColor: Color(0xFFFFFFFF),
  lightCellColor: Color(0xFFFFFFFF),
  darkCellColor: Color(0xFFE0E0E0),
  drawLines: false,
  lineColor: Color(0xFF757575),
  mazeBackColor: Color(0xFF000000),
  mazeForeColor: Color(0xFFE0E0E0),
  pieceForeColor: Color(0xFF000000),
  pieceEdgeColor: Color(0xFF000000),
  deadColor: Color(0xFF757575),
  paralysedColor: Color(0xFFE4E4E4),
  selectableMarkColor: Color(0xFFEA80FC),
  selectedMarkColor: Color(0xFFEA80FC),
  actionMarkColor: Color(0xFFEA80FC),
  movedMarkColor: Color(0xFFBCAAA4),
  partyColor: [
    Color(0xFFF44336), // Ideology.red
    Color(0xFF2196F3), // Ideology.blue
    Color(0xFFFF9800), // Ideology.yellow
    Color(0xFF4CAF50), // Ideology.green
  ],
);
