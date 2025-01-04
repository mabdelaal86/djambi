import 'package:flutter/painting.dart';

enum PieceTheme {
  classic,
  characters,
}

enum BoardTheme {
  classic,
}

enum MarginsVisibility {
  none,
  half,
  full,
}

class BoardStyle {
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

  BoardStyle({
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
