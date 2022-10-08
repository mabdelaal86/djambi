import 'package:flame/extensions.dart';

import 'common.dart';

class Cell {
  final int x, y;

  const Cell(this.x, this.y);

  factory Cell.all(int xy) => Cell(xy, xy);
  factory Cell.zero() => const Cell(0, 0);

  @override
  String toString() => "Cell($x, $y)";

  @override
  bool operator ==(Object other) => other is Cell && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  bool get isMaze => x == Constants.mazeIndex && y == Constants.mazeIndex;
  bool get isDark => x.isEven == y.isEven;
  bool get isValid => (0 <= x && x < Constants.boardSize) && (0 <= y && y < Constants.boardSize);
  int get max => x > y ? x : y;
  int get min => x < y ? x : y;

  Cell operator +(Cell other) => Cell(x + other.x, y + other.y);
  Cell operator -(Cell other) => Cell(x - other.x, y - other.y);
  Cell operator *(Cell other) => Cell(x * other.x, y * other.y);

  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());
  Cell abs() => Cell(x.abs(), y.abs());

  static Iterable<Cell> allCells() sync* {
    for (var x = 0; x < Constants.boardSize; x++) {
      for (var y = 0; y < Constants.boardSize; y++) {
        yield Cell(x, y);
      }
    }
  }

  static Iterable<Cell> normalCells() => allCells().where((c) => !c.isMaze);
}
