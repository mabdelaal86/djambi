import 'common.dart';
import 'parliament.dart';

abstract class Member {
  final Parliament parliament;
  Ideology ideology;

  Member(this.parliament, this.ideology);

  @override
  String toString() => "${ideology.name}:${role.name}";

  Role get role;

  Cell cell = Cell.zero();

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

  Iterable<Cell> canKill() => [];

  Manoeuvre manoeuvre = Manoeuvre.select;
  bool get isActing => manoeuvre.index > Manoeuvre.move1.index;

  void act(Cell cell) {
    if (isDead) return;

    switch (manoeuvre) {
      case Manoeuvre.select:  _actOnSelect(cell); break;
      case Manoeuvre.move1:   _actOnMove1(cell);  break;
      // Unhandled case!
      default:
        print("Unhandled member act stage!");
        break;
    }
  }

  void _actOnSelect(Cell cell) {
    if (cell == this.cell) {
      manoeuvre = Manoeuvre.move1;
    }
  }

  void _actOnMove1(Cell cell) {
    if (canMoveTo().contains(cell)) {
      this.cell = cell;
      manoeuvre = Manoeuvre.kill;
    }
    else if (cell != this.cell) {
      manoeuvre = Manoeuvre.select;
    }
  }
}
