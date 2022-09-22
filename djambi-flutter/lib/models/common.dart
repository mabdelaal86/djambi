import 'dart:math';

import 'package:flame/extensions.dart';

class Cell extends Point<int> {
  const Cell(super.x, super.y);

  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());
  Cell scaled(int fx, int fy) => Cell(x * fx, y * fy);
  Cell movedBy(int dx, int dy) => Cell(x + dx, y + dy);
  Cell operator ~/(int scale) => Cell(x ~/ scale, y ~/ scale);

  factory Cell.all(int xy) => Cell(xy, xy);
  factory Cell.zero() => const Cell(0, 0);
}

extension Vector2Extension on Vector2 {
  Vector2 expanded(Cell cell) => Vector2(x * cell.x, y * cell.y);
  Cell toCell(double factor) => Cell(x ~/ factor, y ~/ factor);
}

// order is important
enum Ideology {
  red,
  blue,
  yellow,
  green,
  ;

  Ideology get next => Ideology.values[(index + 1) % 4];
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
