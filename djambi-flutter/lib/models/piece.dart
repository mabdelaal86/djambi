import 'dart:math';

import 'game.dart';

abstract class Piece {
  late PlayerId playerId;
  late final PieceType type;

  Point<int> cell = const Point(0, 0);

  bool _isDead = false;
  bool get isDead => _isDead;
  void die() => _isDead = true;

  Piece(this.type, this.playerId);
}
