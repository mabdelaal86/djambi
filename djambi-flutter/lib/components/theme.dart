import 'package:flutter/material.dart';

import '../models/common.dart';

abstract class GameTheme {
  Paint get marginPaint;
  Paint get cellBgPaint;
  Paint get mazePaint;
  Paint get deadPaint;
  Paint get linePaint;
  Paint get cellMarkPaint;

  TextStyle get marginTextStyle;
  TextStyle get pieceSymbolStyle;

  Paint getPartyPaint(Ideology ideology);
}

class DefaultTheme extends GameTheme {
  @override
  Paint get marginPaint => Paint()..color = Colors.grey.shade300;

  @override
  Paint get cellBgPaint => Paint()..color = Colors.white;

  @override
  Paint get mazePaint => Paint()..color = Colors.black;

  @override
  Paint get deadPaint => Paint()..color = Colors.grey.shade600;

  @override
  Paint get linePaint => Paint()..color = Colors.black;

  @override
  Paint get cellMarkPaint => Paint()
    ..color = Colors.purpleAccent.shade100
    ..style = PaintingStyle.stroke
    ..strokeWidth = 75;

  @override
  TextStyle get marginTextStyle => const TextStyle(color: Colors.black, fontSize: 300);

  @override
  TextStyle get pieceSymbolStyle => const TextStyle(color: Colors.black, fontSize: 500, fontWeight: FontWeight.bold);

  @override
  Paint getPartyPaint(Ideology ideology) {
    const partyColors = [
      Colors.red,           // Ideology.red
      Colors.indigoAccent,  // Ideology.blue
      Colors.orange,        // Ideology.yellow
      Colors.green,         // Ideology.green
    ];

    return Paint()..color = partyColors[ideology.index];
  }
}
