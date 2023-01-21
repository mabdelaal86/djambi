import 'theme.dart';

enum PieceTheme {
  classic,
  characters,
}

class AppearanceSettings {
  bool drawLines = false;
  PieceTheme pieceTheme = PieceTheme.classic;
  GameTheme gameTheme = DefaultTheme();

  AppearanceSettings._();
  static final AppearanceSettings instance = AppearanceSettings._();
}
