import 'package:stack/stack.dart';

import 'common.dart';
import 'parliament.dart';

abstract class Member {
  final Parliament parliament;
  Ideology ideology;

  Member(this.parliament, this.ideology) {
    origins.push(ideology);
  }

  @override
  String toString() => "${ideology.name}:${role.name}";

  Role get role;

  Cell cell = Cell.zero();

  bool _isDead = false;
  bool get isDead => _isDead;
  void die() => _isDead = true;

  final Stack<Ideology> origins = Stack();

  Iterable<Cell> canMoveTo() sync* {
    const List<Cell> directions = [
      Cell(-1, -1), Cell(0, -1), Cell(1, -1),
      Cell(-1,  0),              Cell(1,  0),
      Cell(-1,  1), Cell(0,  1), Cell(1,  1),
    ];

    directionsLoop:
    for (final direction in directions) {
      for (var cur = cell + direction; cur.isValid(); cur += direction) {
        final member = parliament.getMemberAt(cur);
        if (member != null) {
          if (member.isDead || member.ideology != ideology) {
            yield cur;
          }
          continue directionsLoop; // skip this direction
        }
        yield cur;
      }
    }
  }
}
