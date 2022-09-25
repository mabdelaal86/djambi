import 'dart:math';

import 'package:flame/extensions.dart';

class Cell extends Point<int> {
  const Cell(super.x, super.y);

  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());
  Cell scaled(int fx, int fy) => Cell(x * fx, y * fy);
  Cell movedBy(int dx, int dy) => Cell(x + dx, y + dy);

  factory Cell.all(int xy) => Cell(xy, xy);
  factory Cell.zero() => const Cell(0, 0);
  factory Cell.fromVector2(Vector2 vector, {double factor = 1.0}) => Cell(vector.x ~/ factor, vector.y ~/ factor);
}

// order is important
enum Ideology {
  red,
  blue,
  yellow,
  green,
  ;

  static const Ideology first = red;
  Ideology get next => Ideology.values[(index + 1) % 4];
  Ideology get previous => Ideology.values[(index + 3) % 4];
}

// order is important
enum Role {
  chief,
  assassin,
  reporter,
  diplomat,
  necromobile,
  militant,
}
