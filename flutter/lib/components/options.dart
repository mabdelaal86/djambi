import '../models/enums.dart';

enum PlayerType {
  human,
  aiMaxN,
  ;

  bool get isHuman => this == PlayerType.human;
}

class Options {
  var turnDirection = TurnDirection.anticlockwise;
  var startIdeology = Ideology.red;
  final players = {
    Ideology.red: PlayerType.human,
    Ideology.blue: PlayerType.aiMaxN,
    Ideology.yellow: PlayerType.aiMaxN,
    Ideology.green: PlayerType.aiMaxN,
  };
}
