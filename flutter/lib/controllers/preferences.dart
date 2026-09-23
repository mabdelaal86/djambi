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
const _notationVisibility = (key: 'notation-visibility', val: NotationVisibility.topLeft);
const _gameSpeed = (key: 'game-speed', val: GameSpeed.medium);

// play options
const _turnDirection = (key: 'turn-direction', val: TurnDirection.anticlockwise);
const _startIdeology = (key: 'start-ideology', val: Ideology.red);
const _playerTypes = (
  key: 'player-types',
  val: [PlayerType.human, PlayerType.aiMaxN, PlayerType.aiMaxN, PlayerType.aiMaxN],
);

// ------------------------------------
// preferences controller
// ------------------------------------

class Preferences with ChangeNotifier {
  late final SharedPreferences _prefs;

  new _();

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
    players[index] = players[index].isHuman ? .aiMaxN : .human;
    return _prefs.setString(_playerTypes.key, players.map((e) => e.index).join(',')).then(_notifyListeners);
  }

  Iterable<int> get playerTypeIndexes =>
      _prefs.getString(_playerTypes.key)?.split(',').map(int.parse) ?? _playerTypes.val.map((e) => e.index);
  Iterable<PlayerType> get playerTypes => playerTypeIndexes.map((e) => .values[e]);
}
