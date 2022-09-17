import 'piece.dart';

import 'game.dart';
import 'player.dart';

class Tourney {
  PlayerId _currentPlayerId = PlayerId.red;
  PlayerId get currentPlayerId => _currentPlayerId;

  void nextTurn() {
    _currentPlayerId = _currentPlayerId.next;
  }

  final List<Player> players = [
    Player(PlayerId.red),
  ];

  Player get currentPlayer => players[_currentPlayerId.index];

  Iterable<Piece> allPieces() sync* {
    for (final player in players) {
      for (final piece in player.pieces) {
        yield piece;
      }
    }
  }
}
