enum PieceTheme {
  classic,
  characters,
}

class Settings {
  bool drawLines = false;
  PieceTheme pieceTheme = PieceTheme.classic;

  Settings._();
  static final Settings instance = Settings._();
}
