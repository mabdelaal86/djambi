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
  void die() => _isDead = true;
  bool get isDead => _isDead;
  bool get isAlive => !_isDead;

  final Stack<Ideology> origins = Stack();

  Iterable<Cell> movements() sync* {
    const List<Cell> directions = [
      Cell(-1, -1), Cell(0, -1), Cell(1, -1),
      Cell(-1,  0),              Cell(1,  0),
      Cell(-1,  1), Cell(0,  1), Cell(1,  1),
    ];

    for (final dir in directions) {
      for (var cell = this.cell + dir; cell.isValid(); cell += dir) {
        // check if cell is occupied
        final member = parliament.getMemberAt(cell);
        if (member != null) {
          if (member.isDead || member.ideology != ideology) {
            yield cell;
          }
          break; // stop this direction after first occupied cell
        }
        yield cell;
      }
    }
  }
}
