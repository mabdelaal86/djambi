import 'package:shared_preferences/shared_preferences.dart';

import '../common/utils.dart';
import '../models.dart';
import '../views.dart';

enum GameSpeed {
  fast,
  medium,
  slow;

  Duration get duration => Duration(seconds: switch (this) {
    GameSpeed.fast => 1,
    GameSpeed.medium => 2,
    GameSpeed.slow => 3,
  });
}

// keys
const _marginsVisibility = "margins-visibility";
const _gameSpeed = "game-speed";

const _turnDirection = "turn-direction";
const _startIdeology = "start-ideology";
const _playerTypes = "player-types";

// default values
const _defaultMarginsVisibility = MarginsVisibility.half;
const _defaultGameSpeed = GameSpeed.medium;

const _defaultTurnDirection = TurnDirection.anticlockwise;
const _defaultStartIdeology = Ideology.red;
const _defaultPlayerTypes = [
  PlayerType.human,
  PlayerType.aiMaxN,
  PlayerType.aiMaxN,
  PlayerType.aiMaxN,
];

class PreferencesController {
  late final SharedPreferences _prefs;
  PreferencesController._();

  static Future<PreferencesController> create() async {
    final res = PreferencesController._();
    res._prefs = await SharedPreferences.getInstance();
    return res;
  }

  Future<void> setMarginsVisibility(MarginsVisibility visibility) async {
    await _prefs.setInt(_marginsVisibility, visibility.index);
  }

  MarginsVisibility getMarginsVisibility() => _prefs.getInt(_marginsVisibility)
      ?.convert((e) => MarginsVisibility.values[e])
      ?? _defaultMarginsVisibility;

  Future<void> setGameSpeed(GameSpeed gameSpeed) async {
    await _prefs.setInt(_gameSpeed, gameSpeed.index);
  }

  GameSpeed getGameSpeed() => _prefs.getInt(_gameSpeed)
      ?.convert((e) => GameSpeed.values[e])
      ?? _defaultGameSpeed;

  PieceTheme getPieceTheme() => PieceTheme.classic;
  BoardTheme getBoardTheme() => BoardTheme.classic;

  Future<void> setTurnDirection(TurnDirection direction) async {
    await _prefs.setInt(_turnDirection, direction.index);
  }

  TurnDirection getTurnDirection() => _prefs.getInt(_turnDirection)
      ?.convert((e) => TurnDirection.values[e])
      ?? _defaultTurnDirection;

  Future<void> setStartIdeology(Ideology ideology) async {
    await _prefs.setInt(_startIdeology, ideology.index);
  }

  Ideology getStartIdeology() => _prefs.getInt(_startIdeology)
      ?.convert((e) => Ideology.values[e])
      ?? _defaultStartIdeology;

  Future<void> setPlayerTypes(Iterable<PlayerType> playerTypes) async {
    await _prefs.setString(_playerTypes, playerTypes.map((e) => e.index).join(","));
  }

  List<PlayerType> getPlayerTypes() => _prefs.getString(_playerTypes)
        ?.split(",")
        .map(int.parse)
        .map((e) => PlayerType.values[e])
        .toList() ?? _defaultPlayerTypes;
}
