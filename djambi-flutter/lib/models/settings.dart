enum PieceTheme {
  classic,
  characters,
}

class Settings {
  bool drawLines = false;
  PieceTheme pieceTheme = PieceTheme.characters;

  Settings._();
  static final Settings instance = Settings._();
}
