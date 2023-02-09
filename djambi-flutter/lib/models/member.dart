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
  final String id;

  Member(this.parliament, this.ideology, this.id);

  factory Member.create(Parliament parliament, Role role, Ideology ideology, String id) {
    switch (role) {
      case Role.chief:        return Chief(parliament, ideology, id);
      case Role.assassin:     return Assassin(parliament, ideology, id);
      case Role.reporter:     return Reporter(parliament, ideology, id);
      case Role.diplomat:     return Diplomat(parliament, ideology, id);
      case Role.necromobile:  return Necromobile(parliament, ideology, id);
      case Role.militant:     return Militant(parliament, ideology, id);
    }
  }

  factory Member.copy(Parliament parliament, Member other) =>
      Member.create(parliament, other.role, other.ideology, other.id)
        ..location = other.location
        .._isDead = other._isDead
  ;

  @override
  String toString() => "${ideology.name}:${role.name}($id)";

  Role get role;

  Cell location = const Cell.zero();

  bool _isDead = false;
  bool get isDead => _isDead;
  bool get isAlive => !_isDead;

  @protected
  void kill(Member member) {
    member._isDead = true;
    // take over other members if the killed member is a chief
    if (member.role == Role.chief) {
      for (final other in parliament.getParty(member.ideology).members) {
        other.ideology = ideology;
      }
    }
  }

  Manoeuvre manoeuvre = Manoeuvre.start;

  /// Returns cells that a member can move to.
  ///
  /// The default implementation returns empty cells and cells occupied
  /// by an enemy member or a dead member in all 8 directions.
  Iterable<Cell> cellsToMove(bool canKill) sync* {
    for (final dir in Cell.allDirections) {
      for (Cell cell = location + dir; cell.isValid; cell += dir) {
        // check if cell is occupied
        final member = parliament.getMemberAt(cell);
        if (member != null) {
          // if can kill, cell should be occupied by dead or enemy member
          if (canKill && (member.isDead || member.ideology != ideology)) {
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
    switch (manoeuvre) {
      case Manoeuvre.start:  return cellsToMove(true);
      case Manoeuvre.kill:   return Cell.allCells().where(canKillOn);
      case Manoeuvre.exit:   return cellsToMove(false);
      case Manoeuvre.bury:   return Cell.allCells().where(canBuryOn);
      case Manoeuvre.end:    return [];
    }
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

  @protected
  void endManoeuvre() {
    _body = null;
    _cellFrom = null;
    manoeuvre = Manoeuvre.end;
  }

  void act(Cell cell) {
    if (manoeuvre == Manoeuvre.start) {
      _start(cell);
    }

    // is acting
    if (manoeuvre != Manoeuvre.start && manoeuvre != Manoeuvre.end) {
      proceed(cell);
    }
  }

  @protected
  void proceed(Cell cell);

  void _start(Cell cell) {
    if (!cellsToMove(true).contains(cell)) {
      throw StateError("Can't do an action on the selected cell");
    }
    _body = parliament.getMemberAt(cell);
    _cellFrom = location;
    location = cell;
    manoeuvre = Manoeuvre.kill;
  }
}
