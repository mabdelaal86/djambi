abstract class Configs {
  static const int boardCells = 9;
  static const int mazeIndex = boardCells ~/ 2; // 4
}

enum PlayerId {
  red,
  blue,
  yellow,
  green,
  ;

  PlayerId get next => PlayerId.values[(index + 1) % 4];
}

enum PieceType {
  chief,
  assassin,
  reporter,
  diplomat,
  necromobile,
  militant,
}
