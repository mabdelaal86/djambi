import 'package:flutter/painting.dart';

import '../models/common.dart';

enum PieceTheme {
  classic,
  characters,
}

abstract class BoardTheme {
  // margins
  Paint get marginPaint;
  TextStyle get marginTextStyle;
  // background
  Paint get lightCellPaint;
  Paint get darkCellPaint;
  bool get drawLines;
  Paint get linePaint;
  // maze
  Paint get mazePaint;
  Color get mazeForeColor;
  // pieces
  Color get pieceForeColor;
  Paint get pieceEdgePaint;
  TextStyle get pieceSymbolStyle;
  Paint get deadPaint;
  Paint get selectableMarkPaint;
  Paint get selectedMarkPaint;
  Paint get actionMarkPaint;
  Paint get movedMarkPaint;
  // parties
  Paint getPartyPaint(Ideology ideology);
}

class DefaultBoardTheme extends BoardTheme {
  @override
  Paint get marginPaint => Paint()..color = const Color(0xff757575);

  @override
  TextStyle get marginTextStyle => const TextStyle(
      color: Color(0xffffffff), fontSize: 300, fontWeight: FontWeight.bold);

  @override
  Paint get lightCellPaint => Paint()..color = const Color(0xffffffff);

  @override
  Paint get darkCellPaint => Paint()..color = const Color(0xffe0e0e0);

  @override
  bool get drawLines => false;

  @override
  Paint get linePaint => Paint()
    ..color = const Color(0xff000000)
    ..style = PaintingStyle.stroke;

  @override
  Paint get mazePaint => Paint()..color = const Color(0xff000000);

  @override
  Color get mazeForeColor => const Color(0xffe0e0e0);

  @override
  Color get pieceForeColor => const Color(0xff000000);

  @override
  Paint get pieceEdgePaint => Paint()
    ..color = pieceForeColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 22;

  @override
  TextStyle get pieceSymbolStyle => TextStyle(
      color: pieceForeColor, fontSize: 500, fontWeight: FontWeight.bold);

  @override
  Paint get deadPaint => Paint()..color = const Color(0xff757575);

  @override
  Paint get selectableMarkPaint => Paint()..color = const Color(0xff757575);

  @override
  Paint get selectedMarkPaint => Paint()..color = const Color(0xffea80fc);

  @override
  Paint get actionMarkPaint => Paint()..color = const Color(0xff757575);

  @override
  Paint get movedMarkPaint => Paint()..color = const Color(0xffbcaaa4);

  @override
  Paint getPartyPaint(Ideology ideology) {
    const partyColors = [
      Color(0xfff44336),  // Ideology.red
      Color(0xff2196f3),  // Ideology.blue
      Color(0xffff9800),  // Ideology.yellow
      Color(0xff4caf50),  // Ideology.green
    ];

    return Paint()..color = partyColors[ideology.index];
  }
}
