import 'package:shared_preferences/shared_preferences.dart';

import '../common/utils.dart';
import '../models.dart';
import '../views.dart';

class Preferences {
  late final SharedPreferences _prefs;
  Preferences._();

  static Future<Preferences> getInstance() async {
    final res = Preferences._();
    res._prefs = await SharedPreferences.getInstance();
    return res;
  }

  Future<void> setMarginsVisibility(MarginsVisibility visibility) async {
    await _prefs.setInt("margins-visibility", visibility.index);
  }

  MarginsVisibility getMarginsVisibility() => _prefs.getInt("margins-visibility")
      ?.convert((e) => MarginsVisibility.values[e])
      ?? MarginsVisibility.half;

  PieceTheme getPieceTheme() => PieceTheme.classic;
  BoardTheme getBoardTheme() => BoardTheme.classic;

  Future<void> setTurnDirection(TurnDirection direction) async {
    await _prefs.setInt("turn-direction", direction.index);
  }

  TurnDirection getTurnDirection() => _prefs.getInt("turn-direction")
      ?.convert((e) => TurnDirection.values[e])
      ?? TurnDirection.anticlockwise;

  Future<void> setStartIdeology(Ideology ideology) async {
    await _prefs.setInt("start-ideology", ideology.index);
  }

  Ideology getStartIdeology() => _prefs.getInt("start-ideology")
      ?.convert((e) => Ideology.values[e])
      ?? Ideology.red;

  Future<void> setPlayerTypes(Iterable<PlayerType> playerTypes) async {
    await _prefs.setString("player-types", playerTypes.map((e) => e.index).join(","));
  }

  List<PlayerType> getPlayerTypes() => _prefs.getString("player-types")
        ?.split(",")
        .map(int.parse)
        .map((e) => PlayerType.values[e])
        .toList() ?? [
          PlayerType.human,
          PlayerType.aiMaxN,
          PlayerType.aiMaxN,
          PlayerType.aiMaxN,
        ];
}
