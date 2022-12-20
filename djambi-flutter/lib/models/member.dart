import 'package:meta/meta.dart';

import 'cell.dart';
import 'common.dart';
import 'parliament.dart';

// member roles
import 'members/assassin.dart';
import 'members/chief.dart';
import 'members/diplomat.dart';
import 'members/militant.dart';
import 'members/necromobile.dart';
import 'members/reporter.dart';

abstract class Member {
  final Parliament parliament;
  Ideology ideology;

  Member(this.parliament, this.ideology);

  factory Member.create(Parliament parliament, Role role, Ideology ideology) {
    switch (role) {
      case Role.chief:        return Chief(parliament, ideology);
      case Role.assassin:     return Assassin(parliament, ideology);
      case Role.reporter:     return Reporter(parliament, ideology);
      case Role.diplomat:     return Diplomat(parliament, ideology);
      case Role.necromobile:  return Necromobile(parliament, ideology);
      case Role.militant:     return Militant(parliament, ideology);
    }
  }

  factory Member.copy(Parliament parliament, Member other) =>
      Member.create(parliament, other.role, other.ideology)
        ..location = other.location
        .._isDead = other._isDead;

  @override
  String toString() => "${ideology.name}:${role.name}";

  Role get role;

  Cell location = const Cell.zero();

  bool _isDead = false;
  bool get isDead => _isDead;
  bool get isAlive => !_isDead;

  @protected
  void kill(Member member) {
    member._isDead = true;
    if (member.role == Role.chief) {
      for (final other in parliament.getParty(member.ideology).members) {
        other.ideology = ideology;
      }
    }
  }

  /// Returns cells that a member can move to.
  ///
  /// The default implementation returns empty cells and cells occupied
  /// by an enemy member or a dead member in all 8 directions.
  Iterable<Cell> cellsToMove() sync* {
    for (final dir in Cell.allDirections) {
      for (Cell cell = location + dir; cell.isValid; cell += dir) {
        // check if cell is occupied
        final member = parliament.getMemberAt(cell);
        if (member != null) {
          // if member is waiting (select or move1), it can do action on other members
          // otherwise, it can only move to empty cells
          if (manoeuvre.isWaiting && (member.isDead || member.ideology != ideology)) {
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

  Iterable<Cell> cellsToAct() {
    if (manoeuvre == Manoeuvre.move1 || manoeuvre == Manoeuvre.move2) {
      return cellsToMove();
    }
    if (manoeuvre == Manoeuvre.kill) {
      return Cell.allCells().where(canKillOn);
    }
    if (manoeuvre == Manoeuvre.bury) {
      return Cell.allCells().where(canBuryOn);
    }
    return [];
  }

  bool canKillOn(Cell cell) => cell == location;
  bool canBuryOn(Cell cell) => parliament.isEmpty(cell) && !cell.isMaze;

  bool occupiedByEnemy(Cell cell) {
    final other = parliament.getMemberAt(cell);
    return other != null && other.isAlive && other.ideology != ideology;
  }

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
    if (cellsToMove().contains(cell)) {
      _body = parliament.getMemberAt(cell);
      _cellFrom = location;
      location = cell;
      manoeuvre = Manoeuvre.kill;
    } else if (cell != location) {
      _body = null;
      _cellFrom = null;
      manoeuvre = Manoeuvre.select;
    }
  }
}
