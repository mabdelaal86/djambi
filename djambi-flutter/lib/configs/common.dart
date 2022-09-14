import 'package:flame/extensions.dart';

// Constants
abstract class Constants {
  // Counts
  static const int boardCells = 9;
  static const int mazeIndex = boardCells ~/ 2; // 4

  // Lengths
  static const double cellSide = 1000;
  static const double pieceRadius = 400;
  static final Vector2 cellSize = Vector2.all(Constants.cellSide);
  static final Vector2 gridSize = cellSize * Constants.boardCells.toDouble();
}

// Players
enum Player {
  green,
  yellow,
  blue,
  red,
}
