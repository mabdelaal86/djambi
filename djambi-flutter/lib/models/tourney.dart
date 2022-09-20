import 'dart:math';

import 'common.dart';
import 'piece.dart';
import 'player.dart';

class Tourney {
  PlayerId _currentPlayerId = PlayerId.red;
  PlayerId get currentPlayerId => _currentPlayerId;

  final List<Player> players = [
    Player(PlayerId.red),
    Player(PlayerId.blue),
    Player(PlayerId.yellow),
    Player(PlayerId.green),
  ];

  Player getPlayer(PlayerId playerId) => players[playerId.index];
  Player get currentPlayer => getPlayer(_currentPlayerId);

  Iterable<Piece> allPieces() sync* {
    for (final player in players) {
      for (final piece in player.pieces) {
        yield piece;
      }
    }
  }

  Tourney() {
    _setInitialPositions();
  }

  void nextTurn() {
    _currentPlayerId = _currentPlayerId.next;
  }

  void _setInitialPositions() {
    getPlayer(PlayerId.red).pieces
      .forEach((piece) { piece.cell = piece.cell.scale(1, -1) + const Point(1, 7); });
    getPlayer(PlayerId.blue).pieces
      .forEach((piece) { piece.cell = piece.cell.scale(-1, -1) + const Point(7, 7); });
    getPlayer(PlayerId.yellow).pieces
      .forEach((piece) { piece.cell = piece.cell.scale(-1, 1) + const Point(7, 1); });
    getPlayer(PlayerId.green).pieces
      .forEach((piece) { piece.cell += const Point(1, 1); });
  }

  List<Point<int>> selectableCells() {
    return currentPlayer.pieces.map((p) => p.cell).toList();
  }
}
