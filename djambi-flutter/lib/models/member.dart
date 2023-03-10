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
  final int id;

  Role get role;

  Cell location = const Cell.zero();

  bool _isDead = false;
  bool get isDead => _isDead;
  bool get isAlive => !_isDead;

  Manoeuvre manoeuvre = Manoeuvre.none;

  int? _bodyId;
  Member? get body => _bodyId == null ? null : parliament.members[_bodyId!];

  Member(this.parliament, this.ideology, this.id);

  @override
  String toString() => "${ideology.name}:${role.name}($id)";

  factory Member.create(Parliament parliament, Role role, Ideology ideology, int id) {
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
      Member.create(parliament, other.role, other.ideology, other.id)..copy(other);

  @protected
  void copy(Member other) {
    // not constant properties
    location = other.location;
    _isDead = other._isDead;
    // manoeuvre properties
    manoeuvre = other.manoeuvre;
    _bodyId = other._bodyId;
  }

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
      case Manoeuvre.none:  return cellsToMove(true);
      case Manoeuvre.move:  return Cell.allCells().where(canReportOn);
      case Manoeuvre.kill:  return cellsToMove(false);
      case Manoeuvre.exit:  return Cell.allCells().where(canBuryOn);
      default:
        return [];
    }
  }

  bool canReportOn(Cell cell) => false;
  bool canBuryOn(Cell cell) => parliament.isEmpty(cell) && !cell.isMaze;

  // try to remove this function
  @protected
  void endManoeuvre() {
    manoeuvre = Manoeuvre.none;
    _bodyId = null;
  }

  void act(Cell cell) {
    switch (manoeuvre) {
      case Manoeuvre.none:  onMove(cell); postMove(); break;
      case Manoeuvre.move:  onKill(cell); break;
      case Manoeuvre.kill:  onExit(cell); break;
      case Manoeuvre.exit:  onBury(cell); break;
      default:
        throw StateError("Unhandled state!");
    }
  }

  @protected
  void onMove(Cell cell) {
    if (!cellsToMove(true).contains(cell)) {
      throw StateError("Can't do an action on the selected cell");
    }
    _bodyId = parliament.getMemberAt(cell)?.id;
    location = cell;
    manoeuvre = Manoeuvre.move;
  }

  @protected
  void postMove() => throw StateError("Unhandled state!");

  @protected
  void onKill(Cell cell) => throw StateError("Unhandled state!");

  @protected
  void onExit(Cell cell) => throw StateError("Unhandled state!");

  @protected
  void onBury(Cell cell) {
    if (!canBuryOn(cell)) {
      throw StateError("Can't do an action on the selected cell");
    }
    body!.location = cell;
    endManoeuvre();
  }
}
