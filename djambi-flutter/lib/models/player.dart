import 'dart:math';

import 'piece.dart';
import 'chief.dart';
import 'assassin.dart';
import 'reporter.dart';
import 'diplomat.dart';
import 'necromobile.dart';
import 'militant.dart';
import 'game.dart';

class Player {
  late final PlayerId id;
  List<Piece> pieces = [
    Chief(PlayerId.yellow)..cell = const Point(0, 0),
    Assassin(PlayerId.red)..cell = const Point(0, 1),
    Reporter(PlayerId.green)..cell = const Point(1, 0),
    Diplomat(PlayerId.blue)..cell = const Point(1, 1),
    Necromobile(PlayerId.red)..cell = const Point(2, 0),
    Militant(PlayerId.red)..cell = const Point(2, 1),
    Militant(PlayerId.blue)..cell = const Point(0, 2),
    Militant(PlayerId.green)..cell = const Point(1, 2),
    Militant(PlayerId.red)..cell = const Point(2, 2),
  ];

  Player(this.id) {
    pieces.last.die();
  }
}
