abstract class Constants {
  static const int boardSize = 9;
  static const int mazeIndex = boardSize ~/ 2;
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

enum Role {
  chief,
  assassin,
  reporter,
  diplomat,
  necromobile,
  militant,
}

enum Manoeuvre {
  move,
  report,
  exit,
  bury,
  end,
  ;

  static const Manoeuvre start = move;
}
