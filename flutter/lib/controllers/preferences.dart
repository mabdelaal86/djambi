import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';
import '../models/ai/tree.dart';
import '../views.dart';

enum GameSpeed {
  fast,
  medium,
  slow;

  Duration get duration => Duration(
        seconds: switch (this) {
          GameSpeed.fast => 1,
          GameSpeed.medium => 2,
          GameSpeed.slow => 3,
        },
      );

  String get title => switch (this) {
        GameSpeed.fast => 'Fast',
        GameSpeed.medium => 'Medium',
        GameSpeed.slow => 'Slow',
      };
}

// ── preference keys & defaults ─────────────────────────────────────────────
const _notationVisibility = (
  key: 'notation-visibility',
  val: NotationVisibility.topLeft
);
const _gameSpeed = (key: 'game-speed', val: GameSpeed.medium);
const _aiDifficulty = (key: 'ai-difficulty', val: AiDifficulty.medium);
const _soundEnabled = (key: 'sound-enabled', val: true);
const _turnDirection = (key: 'turn-direction', val: TurnDirection.anticlockwise);
const _startIdeology = (key: 'start-ideology', val: Ideology.red);
const _playerTypes = (
  key: 'player-types',
  val: [
    PlayerType.human,
    PlayerType.aiMaxN,
    PlayerType.aiMaxN,
    PlayerType.aiMaxN,
  ]
);

// ── preferences controller ─────────────────────────────────────────────────
class Preferences with ChangeNotifier {
  late final SharedPreferences _prefs;

  Preferences._();

  static Future<Preferences> create() async {
    final res = Preferences._();
    res._prefs = await SharedPreferences.getInstance();
    return res;
  }

  // ── Game settings ─────────────────────────────────────────────────────────

  Future<void> setNotationVisibility(int v) =>
      _prefs.setInt(_notationVisibility.key, v).then((_) => notifyListeners());
  int get notationVisibilityIndex =>
      _prefs.getInt(_notationVisibility.key) ?? _notationVisibility.val.index;
  NotationVisibility get notationVisibility =>
      NotationVisibility.values[notationVisibilityIndex];

  Future<void> setGameSpeed(int v) =>
      _prefs.setInt(_gameSpeed.key, v).then((_) => notifyListeners());
  int get gameSpeedIndex =>
      _prefs.getInt(_gameSpeed.key) ?? _gameSpeed.val.index;
  GameSpeed get gameSpeed => GameSpeed.values[gameSpeedIndex];

  Future<void> setAiDifficulty(int v) =>
      _prefs.setInt(_aiDifficulty.key, v).then((_) => notifyListeners());
  int get aiDifficultyIndex =>
      _prefs.getInt(_aiDifficulty.key) ?? _aiDifficulty.val.index;
  AiDifficulty get aiDifficulty => AiDifficulty.values[aiDifficultyIndex];

  Future<void> setSoundEnabled(bool v) =>
      _prefs.setBool(_soundEnabled.key, v).then((_) => notifyListeners());
  bool get soundEnabled =>
      _prefs.getBool(_soundEnabled.key) ?? _soundEnabled.val;

  // ── Theme (currently not user-configurable) ───────────────────────────────
  PieceTheme get pieceTheme => PieceTheme.classic;
  BoardTheme get boardTheme => BoardTheme.grayish;

  // ── Play options ──────────────────────────────────────────────────────────

  Future<void> setTurnDirection(int v) =>
      _prefs.setInt(_turnDirection.key, v).then((_) => notifyListeners());
  int get turnDirectionIndex =>
      _prefs.getInt(_turnDirection.key) ?? _turnDirection.val.index;
  TurnDirection get turnDirection => TurnDirection.values[turnDirectionIndex];

  Future<void> setStartIdeology(int v) =>
      _prefs.setInt(_startIdeology.key, v).then((_) => notifyListeners());
  int get startIdeologyIndex =>
      _prefs.getInt(_startIdeology.key) ?? _startIdeology.val.index;
  Ideology get startIdeology => Ideology.values[startIdeologyIndex];

  Future<void> togglePlayerType(int index) {
    final players = playerTypes.toList();
    players[index] =
        players[index].isHuman ? PlayerType.aiMaxN : PlayerType.human;
    return _prefs
        .setString(_playerTypes.key, players.map((e) => e.index).join(','))
        .then((_) => notifyListeners());
  }

  Iterable<int> get playerTypeIndexes =>
      _prefs.getString(_playerTypes.key)?.split(',').map(int.parse) ??
      _playerTypes.val.map((e) => e.index);
  Iterable<PlayerType> get playerTypes =>
      playerTypeIndexes.map((e) => PlayerType.values[e]);
}
