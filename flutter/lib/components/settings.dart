import '../views/theme.dart';

class AppearanceSettings {
  PieceTheme pieceTheme = PieceTheme.classic;
  BoardTheme boardTheme = getDefaultBoardTheme();

  AppearanceSettings._();
  static final AppearanceSettings instance = AppearanceSettings._();
}
