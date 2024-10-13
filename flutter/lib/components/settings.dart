import '../models/common.dart';
import '../views/theme.dart';

class AppearanceSettings {
  var pieceTheme = PieceTheme.classic;
  var boardTheme = getDefaultBoardTheme();

  AppearanceSettings._();
  static final AppearanceSettings instance = AppearanceSettings._();
}

enum PlayerType {
  human,
  aiMaxN,
}

class GameSettings {
  static const actionDuration = Duration(seconds: 1);

  var turnDirection = TurnDirection.anticlockwise;
  var startIdeology = Ideology.red;
  final players = {
    Ideology.red: PlayerType.human,
    Ideology.blue: PlayerType.aiMaxN,
    Ideology.yellow: PlayerType.aiMaxN,
    Ideology.green: PlayerType.aiMaxN,
  };

  GameSettings._();
  static final GameSettings instance = GameSettings._();
}
