import 'dart:math';

import 'assassin.dart';
import 'chief.dart';
import 'common.dart';
import 'diplomat.dart';
import 'militant.dart';
import 'necromobile.dart';
import 'piece.dart';
import 'reporter.dart';

class Player {
  late final PlayerId id;
  late List<Piece> pieces;

  Player(this.id) {
    // create pieces and place them around (0,0) point, so it is easier to rotate or flip
    pieces = [
      Chief(id)        ..cell = const Point(-1, -1),
      Assassin(id)     ..cell = const Point( 0, -1),
      Reporter(id)     ..cell = const Point(-1,  0),
      Diplomat(id)     ..cell = const Point( 0,  0),
      Necromobile(id)  ..cell = const Point( 1,  1),
      Militant(id)     ..cell = const Point(-1,  1),
      Militant(id)     ..cell = const Point( 0,  1),
      Militant(id)     ..cell = const Point( 1,  0),
      Militant(id)     ..cell = const Point( 1, -1),
    ];
  }
}
