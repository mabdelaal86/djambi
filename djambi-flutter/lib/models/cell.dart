import 'package:flame/extensions.dart';

import 'common.dart';

class Cell {
  final int x, y;

  const Cell(this.x, this.y);
  const Cell.zero(): this(0, 0);
  const Cell.all(int xy): this(xy, xy);

  @override
  String toString() => "Cell($x, $y)";

  String get value => "$x$y";

  @override
  bool operator ==(Object other) =>
      other is Cell && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  bool get isMaze => x == Constants.mazeIndex && y == Constants.mazeIndex;
  bool get isDark => x.isEven == y.isEven;
  bool get isValid =>
      (0 <= x && x < Constants.boardSize) &&
      (0 <= y && y < Constants.boardSize);
  int get max => x > y ? x : y;
  int get min => x < y ? x : y;

  Cell operator +(Cell other) => Cell(x + other.x, y + other.y);
  Cell operator -(Cell other) => Cell(x - other.x, y - other.y);
  Cell operator *(Cell other) => Cell(x * other.x, y * other.y);

  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());
  Cell abs() => Cell(x.abs(), y.abs());

  static const List<Cell> allDirections = [
    Cell(-1, -1), Cell(0, -1), Cell(1, -1),
    Cell(-1,  0), /*location*/ Cell(1,  0),
    Cell(-1,  1), Cell(0,  1), Cell(1,  1),
  ];

  static const List<Cell> orthogonalDirections = [
                 Cell(0, -1),
    Cell(-1, 0), /*location*/ Cell(1, 0),
                 Cell(0,  1),
  ];

  bool isAdjacentTo(Cell other) {
    return (x == other.x && (y - other.y).abs() == 1) ||
           (y == other.y && (x - other.x).abs() == 1);
  }

  Iterable<Cell> adjacentCells() => orthogonalDirections.map((d) => this + d).where((c) => c.isValid);

  static Iterable<Cell> allCells() sync* {
    for (int x = 0; x < Constants.boardSize; x++) {
      for (int y = 0; y < Constants.boardSize; y++) {
        yield Cell(x, y);
      }
    }
  }

  static Iterable<Cell> normalCells() => allCells().where((c) => !c.isMaze);
}
