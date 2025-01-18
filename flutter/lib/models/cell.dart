import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';

import 'constants.dart';

@immutable
class Cell {
  final int x, y;

  const Cell(this.x, this.y);
  const Cell.zero() : this(0, 0);
  const Cell.maze() : this(Constants.mazeIndex, Constants.mazeIndex);

  /// json deserialization
  Cell.fromJson(Map<String, dynamic> json) : this(json["x"], json["y"]);

  /// json serialization
  Map<String, dynamic> toJson() => {"x": x, "y": y};

  @override
  String toString() => isValid
      ? Constants.colSymbols[x] + Constants.rowSymbols[y]
      : "$x,$y";

  @override
  bool operator ==(Object other) =>
      other is Cell && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  bool get isMaze => x == Constants.mazeIndex && y == Constants.mazeIndex;
  bool get isDark => x.isEven == y.isEven;
  bool get isValid =>
      (0 <= x && x < Constants.sideCellsCount) &&
      (0 <= y && y < Constants.sideCellsCount);
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

  Iterable<Cell> surroundingCells() =>
      allDirections.map((d) => this + d).where((c) => c.isValid);

  static const List<Cell> orthogonalDirections = [
                 Cell(0, -1),
    Cell(-1, 0), /*location*/ Cell(1, 0),
                 Cell(0,  1),
  ];

  bool isAdjacentTo(Cell other) =>
      (x == other.x && (y - other.y).abs() == 1) ||
      (y == other.y && (x - other.x).abs() == 1);

  Iterable<Cell> adjacentCells() =>
      orthogonalDirections.map((d) => this + d).where((c) => c.isValid);

  static Iterable<Cell> allCells() sync* {
    for (var y = 0; y < Constants.sideCellsCount; y++) {
      for (var x = 0; x < Constants.sideCellsCount; x++) {
        yield Cell(x, y);
      }
    }
  }

  static Iterable<Cell> normalCells() => allCells().where((c) => !c.isMaze);
}
