import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';
import '../views.dart';

enum GameSpeed {
  fast,
  medium,
  slow;

  Duration get duration => Duration(
    seconds: switch (this) {
      .fast => 1,
      .medium => 2,
      .slow => 3,
    },
  );
}

// ------------------------------------
// preferences (key, default value)
// ------------------------------------

// game settings
const _notationVisibility = (key: "notation-visibility", val: NotationVisibility.topLeft);
const _gameSpeed = (key: "game-speed", val: GameSpeed.medium);
const _soundEnabled = (key: "sound-enabled", val: true);

// play options
const _turnDirection = (key: "turn-direction", val: TurnDirection.anticlockwise);
const _startIdeology = (key: "start-ideology", val: Ideology.red);
const _playerTypes = (
  key: "player-types",
  val: [PlayerType.human, PlayerType.aiMedium, PlayerType.aiMedium, PlayerType.aiMedium],
);

// ------------------------------------
// preferences controller
// ------------------------------------

class Preferences with ChangeNotifier {
  late final SharedPreferences _prefs;

  Preferences._();

  static Future<Preferences> create() async {
    final res = Preferences._();
    res._prefs = await SharedPreferences.getInstance();
    return res;
  }

  void _notifyListeners(bool _) => notifyListeners();

  // --------------
  // game settings
  // --------------

  // notation visibility
  Future<void> setNotationVisibility(int value) => _prefs.setInt(_notationVisibility.key, value).then(_notifyListeners);
  int get notationVisibilityIndex => _prefs.getInt(_notationVisibility.key) ?? _notationVisibility.val.index;
  NotationVisibility get notationVisibility => .values[notationVisibilityIndex];

  // game speed
  Future<void> setGameSpeed(int value) => _prefs.setInt(_gameSpeed.key, value).then(_notifyListeners);
  int get gameSpeedIndex => _prefs.getInt(_gameSpeed.key) ?? _gameSpeed.val.index;
  GameSpeed get gameSpeed => .values[gameSpeedIndex];

  // sound effects
  Future<void> setSoundEnabled(bool value) => _prefs.setBool(_soundEnabled.key, value).then(_notifyListeners);
  bool get soundEnabled => _prefs.getBool(_soundEnabled.key) ?? _soundEnabled.val;

  // theme
  PieceTheme get pieceTheme => .classic;
  BoardTheme get boardTheme => .grayish;

  // --------------
  // play options
  // --------------

  // turn direction
  Future<void> setTurnDirection(int value) => _prefs.setInt(_turnDirection.key, value).then(_notifyListeners);
  int get turnDirectionIndex => _prefs.getInt(_turnDirection.key) ?? _turnDirection.val.index;
  TurnDirection get turnDirection => .values[turnDirectionIndex];

  // start ideology
  Future<void> setStartIdeology(int value) => _prefs.setInt(_startIdeology.key, value).then(_notifyListeners);
  int get startIdeologyIndex => _prefs.getInt(_startIdeology.key) ?? _startIdeology.val.index;
  Ideology get startIdeology => .values[startIdeologyIndex];

  // player types
  Future<void> togglePlayerType(int index) {
    final players = playerTypes.toList();
    players[index] = players[index].isHuman ? .aiMedium : .human;
    return _setPlayerTypes(players);
  }

  /// Sets the AI difficulty for a non-human player slot. Has no effect on
  /// whether the slot is human or AI - use [togglePlayerType] for that.
  Future<void> setPlayerDifficulty(int index, PlayerType difficulty) {
    assert(difficulty.isAi, "difficulty must be one of the AI player types");
    final players = playerTypes.toList();
    if (players[index].isHuman) return Future.value();
    players[index] = difficulty;
    return _setPlayerTypes(players);
  }

  Future<void> _setPlayerTypes(List<PlayerType> players) =>
      _prefs.setString(_playerTypes.key, players.map((e) => e.index).join(",")).then(_notifyListeners);

  Iterable<int> get playerTypeIndexes =>
      _prefs.getString(_playerTypes.key)?.split(",").map(int.parse) ?? _playerTypes.val.map((e) => e.index);
  Iterable<PlayerType> get playerTypes => playerTypeIndexes.map((e) => .values[e]);
}
