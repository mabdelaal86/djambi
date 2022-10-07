import 'package:flame/extensions.dart';

abstract class Constants {
  static const int boardSize = 9;
  static const int mazeIndex = boardSize ~/ 2;
  static final Cell mazeCell = Cell.all(mazeIndex);
}

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

  Cell operator +(Cell other) => Cell(x + other.x, y + other.y);
  Cell operator -(Cell other) => Cell(x - other.x, y - other.y);
  Cell operator *(Cell other) => Cell(x * other.x, y * other.y);

  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());
  Cell abs() => Cell(x.abs(), y.abs());
  int max() => x > y ? x : y;
  int min() => x < y ? x : y;
  bool isValid() =>
      (0 <= x && x < Constants.boardSize) &&
      (0 <= y && y < Constants.boardSize);

  static Iterable<Cell> allCells() sync* {
    for (var x = 0; x < Constants.boardSize; x++) {
      for (var y = 0; y < Constants.boardSize; y++) {
        yield Cell(x, y);
      }
    }
  }

  static Iterable<Cell> normalCells() => allCells().where((c) => !c.isMaze);
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

// order is important
enum Manoeuvre {
  select,
  move1,
  kill,
  move2,
  bury,
  end,
  ;

  bool get isWaiting => this == select || this == move1;
  bool get isFinished => this == end;
  bool get isActing => !isWaiting && !isFinished;
}
