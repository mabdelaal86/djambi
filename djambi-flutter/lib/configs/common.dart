// Constants
class Constants {
  // Counts
  static const int boardCells = 9;
  static const int mazeIndex = boardCells ~/ 2; // 4

  // Lengths
  static const double cellSide = 1000;
  static const double pieceRadius = 400;
}

// Players
enum Player {
  green,
  yellow,
  blue,
  red,
}
