import 'package:meta/meta.dart';

import 'common.dart';
import 'parliament.dart';

abstract class Member {
  final Parliament parliament;
  Ideology ideology;

  Member(this.parliament, this.ideology);

  @override
  String toString() => "${ideology.name}:${role.name}";

  Role get role;

  Cell location = Cell.zero();

  bool _isDead = false;
  void die() => _isDead = true;
  bool get isDead => _isDead;
  bool get isAlive => !_isDead;

  /// Returns cells that a member can move to.
  ///
  /// The default implementation returns empty cells and cells occupied
  /// by an enemy member or a dead member in all 8 directions.
  Iterable<Cell> canMoveTo() sync* {
    const List<Cell> directions = [
      Cell(-1, -1), Cell(0, -1), Cell(1, -1),
      Cell(-1,  0),              Cell(1,  0),
      Cell(-1,  1), Cell(0,  1), Cell(1,  1),
    ];

    for (final dir in directions) {
      for (var cell = location + dir; cell.isValid(); cell += dir) {
        // check if cell is occupied
        final member = parliament.getMemberAt(cell);
        if (member != null) {
          if (manoeuvre == Manoeuvre.move1 && (member.isDead || member.ideology != ideology)) {
            // occupied with dead or enemy member
            yield cell;
          }
          break; // stop this direction after first occupied cell
        }
        // empty cell
        yield cell;
      }
    }
  }

  Iterable<Cell> canKill() => [];

  Iterable<Cell> canBury() => Cell.normalCells().where(parliament.isEmpty);

  Member? _body;
  Member? get body => _body;

  Cell? _cellFrom;
  Cell? get cellFrom => _cellFrom;

  Manoeuvre manoeuvre = Manoeuvre.select;

  @protected
  void endManoeuvre() {
    _body = null;
    _cellFrom = null;
    manoeuvre = Manoeuvre.end;
  }

  void act(Cell cell) {
    if (manoeuvre == Manoeuvre.select) {
      _actOnSelect(cell);
    } else if (manoeuvre == Manoeuvre.move1) {
      _actOnMove1(cell);
    }

    if (manoeuvre.isActing) {
      proceed(cell);
    }
  }

  @protected
  void proceed(Cell cell);

  void _actOnSelect(Cell cell) {
    if (cell == location) {
      manoeuvre = Manoeuvre.move1;
    }
  }

  void _actOnMove1(Cell cell) {
    if (canMoveTo().contains(cell)) {
      _body = parliament.getMemberAt(cell);
      _cellFrom = location;
      location = cell;
      manoeuvre = Manoeuvre.kill;
    }
    else if (cell != location) {
      _body = null;
      _cellFrom = null;
      manoeuvre = Manoeuvre.select;
    }
  }
}
