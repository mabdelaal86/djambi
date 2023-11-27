import '../views/theme.dart';
import 'theme.dart';

class AppearanceSettings {
  PieceTheme pieceTheme = PieceTheme.classic;
  BoardTheme boardTheme = getDefaultBoardTheme();
  GuiTheme guiTheme = GuiTheme();

  AppearanceSettings._();
  static final AppearanceSettings instance = AppearanceSettings._();
}
