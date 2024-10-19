import 'package:flutter/painting.dart';

import 'dimensions.dart' as dimensions;
import 'utils.dart';

enum PieceTheme {
  classic,
  characters,
}

class BoardTheme {
  // margins
  final Paint marginPaint;
  final TextStyle marginTextStyle;
  // background
  final Paint lightCellPaint;
  final Paint darkCellPaint;
  final bool drawLines;
  final Paint linePaint;
  // maze
  final Paint mazePaint;
  final Color mazeForeColor;
  // pieces
  final Color pieceForeColor;
  final Paint pieceEdgePaint;
  final TextStyle pieceSymbolStyle;
  final Paint deadPaint;
  final Paint paralysedPaint;
  final Paint selectableMarkPaint;
  final Paint selectedMarkPaint;
  final Paint actionMarkPaint;
  final Paint movedMarkPaint;
  // parties
  final List<Paint> partyPaint;

  BoardTheme({
    required this.marginPaint,
    required this.marginTextStyle,
    required this.lightCellPaint,
    required this.darkCellPaint,
    required this.drawLines,
    required this.linePaint,
    required this.mazePaint,
    required this.mazeForeColor,
    required this.pieceForeColor,
    required this.pieceEdgePaint,
    required this.pieceSymbolStyle,
    required this.deadPaint,
    required this.paralysedPaint,
    required this.selectableMarkPaint,
    required this.selectedMarkPaint,
    required this.actionMarkPaint,
    required this.movedMarkPaint,
    required this.partyPaint,
  });
}

BoardTheme getDefaultBoardTheme() {
  const pieceForeColor = Color(0xFF000000);
  return BoardTheme(
    marginPaint: const Color(0xFF757575).paint(),
    marginTextStyle: const TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: dimensions.marginFontSize,
      fontWeight: FontWeight.bold,
    ),
    lightCellPaint: const Color(0xFFFFFFFF).paint(),
    darkCellPaint: const Color(0xFFE0E0E0).paint(),
    drawLines: false,
    linePaint: Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke,
    mazePaint: const Color(0xFF000000).paint(),
    mazeForeColor: const Color(0xFFE0E0E0),
    pieceForeColor: pieceForeColor,
    pieceEdgePaint: Paint()
      ..color = pieceForeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = dimensions.pieceStroke,
    pieceSymbolStyle: const TextStyle(
      color: pieceForeColor,
      fontSize: dimensions.pieceFontSize,
      fontWeight: FontWeight.bold,
    ),
    deadPaint: const Color(0xFF757575).paint(),
    paralysedPaint: const Color(0xFFE4E4E4).paint(),
    selectableMarkPaint: const Color(0xFF757575).paint(),
    selectedMarkPaint: const Color(0xFFEA80FC).paint(),
    actionMarkPaint: const Color(0xFF757575).paint(),
    movedMarkPaint: const Color(0xFFBCAAA4).paint(),
    partyPaint: [
      const Color(0xFFF44336).paint(), // Ideology.red
      const Color(0xFF2196F3).paint(), // Ideology.blue
      const Color(0xFFFF9800).paint(), // Ideology.yellow
      const Color(0xFF4CAF50).paint(), // Ideology.green
    ],
  );
}
