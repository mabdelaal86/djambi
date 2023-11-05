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
  bool get isChief => role == Role.chief;

  Cell location = const Cell.zero();

  bool _isDead = false;
  bool get isDead => _isDead;
  bool get isAlive => !_isDead;

  Manoeuvre manoeuvre = Manoeuvre.none;

  int? _bodyId;
  Member? get body => _bodyId == null ? null : parliament.members[_bodyId!];

  Member(this.parliament, this.ideology, this.id);

  @override
  String toString() => "${ideology.name}:${role.name}($location)";

  factory Member.create(Parliament parliament, Role role, Ideology ideology, int id) =>
      switch (role) {
        Role.chief =>         Chief(parliament, ideology, id),
        Role.assassin =>      Assassin(parliament, ideology, id),
        Role.reporter =>      Reporter(parliament, ideology, id),
        Role.diplomat =>      Diplomat(parliament, ideology, id),
        Role.necromobile =>   Necromobile(parliament, ideology, id),
        Role.militant =>      Militant(parliament, ideology, id),
      };

  factory Member.copy(Parliament parliament, Member other) =>
      Member.create(parliament, other.role, other.ideology, other.id)
        ..copyFrom(other);

  @protected
  void copyFrom(Member other) {
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
    if (member.isChief) {
      parliament.getParty(member.ideology).aliveMembers.forEach((m) => m.ideology = ideology);
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

  Iterable<Cell> cellsToAct() => switch (manoeuvre) {
      Manoeuvre.none => cellsToMove(true),
      Manoeuvre.move => Cell.allCells().where(canKillOn),
      Manoeuvre.kill => cellsToMove(false),
      Manoeuvre.exit => Cell.allCells().where(canBuryOn),
      Manoeuvre.end =>  const Iterable.empty(),
    };

  bool canKillOn(Cell cell) => false;
  bool canBuryOn(Cell cell) => !cell.isMaze && parliament.isEmpty(cell);

  void act(Cell cell) {
    switch (manoeuvre) {
      case Manoeuvre.none:  onMove(cell); postMove();
      case Manoeuvre.move:  onKill(cell);
      case Manoeuvre.kill:  onExit(cell);
      case Manoeuvre.exit:  onBury(cell);
      case Manoeuvre.end:   throw AssertionError("Can't act on the `end` state!");
    }
  }

  @protected
  void onMove(Cell cell) {
    assert(cellsToMove(true).contains(cell),
        "Can't do an action on the selected cell");
    _bodyId = parliament.getMemberAt(cell)?.id;
    location = cell;
    manoeuvre = Manoeuvre.move;
  }

  @protected
  void postMove() => throw UnsupportedError("Unhandled state!");

  @protected
  void onKill(Cell cell) => throw UnsupportedError("Unhandled state!");

  @protected
  void onExit(Cell cell) {
    assert(cellsToMove(false).contains(cell),
        "Can't do an action on the selected cell");
    location = cell;
    manoeuvre = Manoeuvre.exit;
  }

  @protected
  void onBury(Cell cell) {
    assert(canBuryOn(cell), "Can't do an action on the selected cell");
    body!.location = cell;
    manoeuvre = Manoeuvre.end;
  }
}
